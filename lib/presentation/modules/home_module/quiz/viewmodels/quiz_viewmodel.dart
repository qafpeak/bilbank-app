import 'package:flutter/material.dart';
import '../../../../../data/socketService/game_socket_service.dart';
import '../../../../../data/local_storage/local_storage.dart';
import '../../../../../data/local_storage/local_storage_impl.dart';
import '../../../../../data/local_storage/local_storage_keys.dart';
import '../models/quiz_models.dart';

class QuizViewModel extends ChangeNotifier {
  static QuizViewModel? _instance;
  static QuizViewModel get instance => _instance ??= QuizViewModel._();
  QuizViewModel._();

  final GameSocketService _socketService = GameSocketService();
  final LocalStorage _localStorage = LocalStorageImpl();
  
  QuizData _quizData = QuizData();
  QuizData get quizData => _quizData;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Initialize the quiz system
  Future<void> initialize(String token) async {
    try {
      _clearError();
      print('🔍 [DEBUG] QuizViewModel initialize started');
      
      // If no token provided, get it from local storage
      String finalToken = token;
      if (token.isEmpty) {
        print('🔍 [DEBUG] Token empty, getting from local storage...');
        finalToken = await _localStorage.getValue<String>(
          LocalStorageKeys.accessToken, 
          '',
        );
        if (finalToken.isEmpty) {
          print('🔍 [ERROR] No token found in local storage');
          _setError('Kullanıcı token\'ı bulunamadı. Lütfen tekrar giriş yapın.');
          return;
        }
        print('🔍 [DEBUG] Token retrieved from local storage');
      } else {
        print('🔍 [DEBUG] Token provided as parameter');
      }
      
      // Disconnect any existing connection first
      if (_socketService.isConnected) {
        print('🔍 [DEBUG] Disconnecting existing socket connection...');
        _socketService.disconnect();
        await Future.delayed(const Duration(milliseconds: 500));
      }
      
      // Initialize socket service
      print('🔍 [DEBUG] Initializing socket service...');
      _socketService.initialize(token: finalToken);
      
      // Set up event listeners
      print('🔍 [DEBUG] Setting up event listeners...');
      _setupSocketListeners();
      
      // Connect to socket and wait for connection
      print('🔍 [DEBUG] Connecting to socket...');
      _socketService.connect();
      
      // Wait a moment for the connection to establish
      await Future.delayed(const Duration(milliseconds: 1500)); // Increased wait time
      
      print('🔍 [DEBUG] Socket initialization completed. Connected: ${_socketService.isConnected}');
      notifyListeners();
    } catch (e) {
      print('🔍 [ERROR] Initialize error: $e');
      _setError('Bağlantı hatası: $e');
    }
  }

  // Join a specific room
  Future<void> joinRoom(String roomId) async {
    try {
      _clearError();
      print('🔍 [DEBUG] joinRoom started for roomId: $roomId');
      
      // Wait for socket connection if not connected yet
      int attempts = 0;
      print('🔍 [DEBUG] Checking socket connection...');
      while (!_socketService.isConnected && attempts < 25) { // Increased to 25 attempts (5 seconds)
        print('🔍 [DEBUG] Socket not connected, attempt $attempts/25');
        await Future.delayed(const Duration(milliseconds: 200));
        attempts++;
      }
      
      print('🔍 [DEBUG] Socket connection status: ${_socketService.isConnected}');
      if (!_socketService.isConnected) {
        print('🔍 [DEBUG] Socket connection failed after 25 attempts');
        _setError('Socket bağlantısı kurulamadı. Lütfen tekrar deneyin.');
        return;
      }
      
      print('🔍 [DEBUG] Socket connected, joining room...');
      _socketService.joinRoom(roomId);
      
      // Update quiz data with room info
      _quizData = _quizData.copyWith(
        roomId: roomId,
        state: QuizState.waiting,
        trivaBalance: 15, // Örnek: Her yarışma başında max 15 çark
      );
      
      print('🔍 [DEBUG] Room join completed, waiting for server events...');
      notifyListeners();
    } catch (e) {
      print('🔍 [ERROR] joinRoom error: $e');
      _setError('Odaya katılım hatası: $e');
    }
  }

  // Send answer to the server
  void sendAnswer(bool answer, {int wheelMultiplier = 1}) {
    if (_quizData.state == QuizState.playing && 
        _quizData.currentQuestion != null &&
        _quizData.roomId != null) {
      // Eğer çark ile cevap veriliyorsa wheelMultiplier > 1 olmalı
      final isWheel = wheelMultiplier > 1;
      _socketService.sendAnswer(
        roomId: _quizData.roomId!,
        questionId: _quizData.currentQuestion!.id,
        answer: answer,
        multiplier: isWheel ? 1 : 1, // Normalde multiplier backend'de 1, çark ile ise wheelMultiplier kullanılıyor
        wheelMultiplier: isWheel ? wheelMultiplier : 1,
      );
    }
  }

  // Setup socket event listeners
  void _setupSocketListeners() {
    _socketService.setEventCallback((event, data) {
      print('🔍 [DEBUG] Received event: $event with data: $data');
      switch (event) {
        case 'connect':
          _handleConnect();
          break;
        case 'disconnect':
          _handleDisconnect();
          break;
        case 'connectError':
          _handleConnectError(data);
          break;
        case 'error':
          _handleConnectError(data);
          break;
        case 'hello':
          _handleHello(data);
          break;
        case 'userJoined':
          _handleUserJoined(data);
          break;
        case 'userLeft':
          _handleUserLeft(data);
          break;
        case GameSocketEvents.timeLeft:
          _handleCountdown(data);
          break;
        case GameSocketEvents.roomStarted:
          _handleRoomStarted(data);
          break;
        case GameSocketEvents.intervalPing:
          _handleQuestion(data);
          break;
        case GameSocketEvents.intervalTimeLeft:
          _handleQuestionTimer(data);
          break;
        case GameSocketEvents.answerResult:
          _handleAnswerResult(data);
          break;
        case GameSocketEvents.score:
          _handleScore(data);
          break;
        case GameSocketEvents.rankResult:
          _handleRank(data);
          break;
        case GameSocketEvents.joined:
          _handleJoined(data);
          break;
        default:
          print('🔍 [DEBUG] Unhandled event: $event');
          break;
      }
    });
  }

  // Event handlers
  void _handleConnect() {
    _isConnected = true;
    _clearError();
    notifyListeners();
  }

  void _handleDisconnect() {
    _isConnected = false;
    _setError('Bağlantı kesildi');
    notifyListeners();
  }

  void _handleConnectError(dynamic error) {
    _isConnected = false;
    _setError('Bağlantı hatası: $error');
    notifyListeners();
  }

  void _handleHello(dynamic data) {
    print('🔍 [DEBUG] Server hello received: $data');
    // Server connection established
  }

  void _handleUserJoined(dynamic data) {
    print('🔍 [DEBUG] User joined: $data');
    // Another user joined the room
  }

  void _handleUserLeft(dynamic data) {
    print('🔍 [DEBUG] User left: $data');
    // Another user left the room
  }

  void _handleCountdown(dynamic data) {
    print('🔍 [DEBUG] Countdown data received: $data (type: ${data.runtimeType})');
    
    int timeLeft = 0;
    
    // Handle different data formats from backend
    if (data is int) {
      timeLeft = data;
    } else if (data is Map<String, dynamic>) {
      timeLeft = data['timeLeft'] as int? ?? data['time'] as int? ?? 0;
    } else if (data is String) {
      timeLeft = int.tryParse(data) ?? 0;
    }
    
    print('🔍 [DEBUG] Parsed timeLeft: $timeLeft');
    
    if (timeLeft > 0) {
      _quizData = _quizData.copyWith(
        state: QuizState.waiting,
        countdown: timeLeft,
      );
      print('🔍 [DEBUG] Updated countdown to: $timeLeft');
      notifyListeners();
    }
  }

  void _handleRoomStarted(dynamic data) {
    _quizData = _quizData.copyWith(
      state: QuizState.playing,
      countdown: 0,
    );
    notifyListeners();
  }

  void _handleQuestion(dynamic data) {
    print('🔍 [DEBUG] Question data received: $data (type: ${data.runtimeType})');
    
    if (data is Map<String, dynamic>) {
      try {
        final question = QuestionData.fromJson(data);
        _quizData = _quizData.copyWith(
          state: QuizState.playing,
          currentQuestion: question,
          questionTimeLeft: 15, // Default question time
        );
        print('🔍 [DEBUG] Question updated: ${question.question}');
        notifyListeners();
      } catch (e) {
        print('🔍 [ERROR] Failed to parse question: $e');
        _setError('Soru verisi hatalı: $e');
      }
    } else {
      print('🔍 [ERROR] Invalid question data format');
    }
  }

  void _handleQuestionTimer(dynamic data) {
    print('🔍 [DEBUG] Question timer data received: $data (type: ${data.runtimeType})');
    
    int timeLeft = 0;
    
    // Handle different data formats
    if (data is int) {
      timeLeft = data;
    } else if (data is Map<String, dynamic>) {
      timeLeft = data['timeLeft'] as int? ?? data['time'] as int? ?? 0;
    } else if (data is String) {
      timeLeft = int.tryParse(data) ?? 0;
    }
    
    print('🔍 [DEBUG] Parsed question timeLeft: $timeLeft');
    
    _quizData = _quizData.copyWith(
      questionTimeLeft: timeLeft,
    );
    notifyListeners();
  }

  void _handleAnswerResult(dynamic data) {
    if (data is Map<String, dynamic>) {
      final result = AnswerResult.fromJson(data);
      _quizData = _quizData.copyWith(
        lastAnswerResult: result,
      );
      notifyListeners();
    }
  }

  void _handleScore(dynamic data) {
    if (data is Map<String, dynamic> && data['score'] is int) {
      _quizData = _quizData.copyWith(
        score: data['score'] as int,
      );
      notifyListeners();
    }
  }

  void _handleRank(dynamic data) {
    print('🔍 [DEBUG] Rank data received: $data');
    
    if (data is Map<String, dynamic>) {
      if (data['ok'] == true) {
        try {
          final rankingData = RankingData.fromJson(data);
          _quizData = _quizData.copyWith(rankingData: rankingData);
          
          print('🏆 [DEBUG] Ranking updated: ${rankingData.rankings.length} items');
          if (rankingData.myRank != null) {
            print('🏆 [DEBUG] My rank: ${rankingData.myRank!.displayText}');
          }
          
          notifyListeners();
        } catch (e) {
          print('🔍 [ERROR] Ranking data parse error: $e');
        }
      } else {
        print('🔍 [ERROR] Ranking request failed: ${data['error']}');
      }
    }
  }

  void _handleJoined(dynamic data) {
    print('🔍 [DEBUG] Successfully joined room: $data');
    _isConnected = true;
    _clearError();
    notifyListeners();
  }

  // Connection status check
  bool get isSocketConnected => _socketService.isConnected;

  // Retry connection
  Future<void> retryConnection() async {
    print('🔍 [DEBUG] Retrying connection...');
    _clearError();
    _socketService.disconnect();
    await Future.delayed(const Duration(milliseconds: 1000));
    _socketService.connect();
    
    // Wait for connection
    int attempts = 0;
    while (!_socketService.isConnected && attempts < 15) {
      await Future.delayed(const Duration(milliseconds: 300));
      attempts++;
    }
    
    if (_socketService.isConnected) {
      print('🔍 [DEBUG] Retry successful');
      _isConnected = true;
      notifyListeners();
    } else {
      print('🔍 [DEBUG] Retry failed');
      _setError('Bağlantı yeniden kurulamadı');
    }
  }

  // Request ranking
  void requestRanking() {
    if (_quizData.roomId != null) {
      _socketService.requestRanking(_quizData.roomId!);
    }
  }

  // Helper methods
  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Clear ranking data after modal is shown
  void clearRankingData() {
    _quizData = _quizData.copyWith(clearRankingData: true);
    notifyListeners();
  }

  // Clean up resources
  @override
  void dispose() {
    _socketService.disconnect();
    super.dispose();
  }

  // Reset quiz state (for new games)
  void reset() {
    _quizData = QuizData();
    _clearError();
    notifyListeners();
  }

  // Get formatted countdown text
  String getCountdownText() {
    if (_quizData.countdown > 0) {
      return '${_quizData.countdown}';
    }
    return '';
  }

  // Get formatted question timer text
  String getQuestionTimerText() {
    if (_quizData.questionTimeLeft > 0) {
      return '${_quizData.questionTimeLeft}';
    }
    return '';
  }

  // Check if we can send answer
  bool canSendAnswer() {
    return _quizData.state == QuizState.playing && 
           _quizData.currentQuestion != null && 
           _quizData.questionTimeLeft > 0;
  }

  // Get progress value for countdown (0.0 to 1.0)
  double getCountdownProgress() {
    if (_quizData.countdown > 0) {
      return 1.0 - (_quizData.countdown / 30.0);
    }
    return 1.0;
  }

  // Get progress value for question timer (0.0 to 1.0)
  double getQuestionProgress() {
    if (_quizData.questionTimeLeft > 0) {
      return 1.0 - (_quizData.questionTimeLeft / 15.0);
    }
    return 1.0;
  }

  // Get ranking data from server
  void getRanking() {
    try {
      if (!_socketService.isConnected) {
        print('🔍 [DEBUG] Cannot get ranking: socket not connected');
        return;
      }

      if (_quizData.roomId == null || _quizData.roomId!.isEmpty) {
        print('🔍 [DEBUG] Cannot get ranking: no room ID');
        return;
      }

      print('🔍 [DEBUG] Requesting ranking for room: ${_quizData.roomId}');
      _socketService.requestRanking(_quizData.roomId!);
    } catch (e) {
      print('🔍 [ERROR] Get ranking error: $e');
    }
  }
}