import 'dart:developer';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bilbank_app/core/api_constants.dart';

/// Backend'den gelen event'ler için modeller
class GameSocketEvents {
  static const String timeLeft = 'timeLeft';           // 30s countdown
  static const String intervalPing = 'intervalPing';   // Sorular
  static const String intervalTimeLeft = 'intervalTimeLeft'; // 15s timer
  static const String roomStarted = 'roomStarted';     // Oda başladı
  static const String roomReady = 'roomReady';         // Oda hazır
  static const String answerResult = 'answerResult';   // Cevap sonucu
  static const String score = 'score';                 // Skor
  static const String rankResult = 'rankResult';       // Sıralama
  static const String joined = 'joined';               // Odaya katıldı
}

/// Socket event callback tipi
typedef SocketEventCallback = void Function(String event, dynamic data);

/// Game Socket Service - Temiz ve basit
class GameSocketService {
  static final GameSocketService _instance = GameSocketService._internal();
  factory GameSocketService() => _instance;
  GameSocketService._internal();

  IO.Socket? _socket;
  String? _token;
  SocketEventCallback? _eventCallback;

  /// Event callback'i ayarla
  void setEventCallback(SocketEventCallback callback) {
    _eventCallback = callback;
  }

  /// Socket bağlı mı?
  bool get isConnected => _socket?.connected ?? false;

  /// Socket'i başlat
  void initialize({required String token}) {
    _token = token;
    log('🎮 Initializing GameSocket with token...', name: 'GameSocket');
    
    if (isConnected) {
      log('🔄 Already connected, skipping init', name: 'GameSocket');
      return;
    }

    _createSocket();
    _registerEventListeners();
    log('✅ GameSocket initialized', name: 'GameSocket');
  }

  /// Socket bağlantısını başlat
  void connect() {
    log('🔌 Connecting to game server...', name: 'GameSocket');
    _socket?.connect();
  }

  /// Bağlantıyı kes
  void disconnect() {
    log('❌ Disconnecting from game server...', name: 'GameSocket');
    _socket?.disconnect();
  }

  /// Odaya katıl
  void joinRoom(String roomId) {
    log('🚪 Joining room: $roomId', name: 'GameSocket');
    _socket?.emit('joinRoom', {'roomId': roomId});
  }

  /// Cevap gönder
  void sendAnswer({
    required String roomId,
    required String questionId,
    required bool answer,
    required int multiplier,
    int? wheelMultiplier,
  }) {
    log('✍️ Sending answer: $answer (x$multiplier, wheel: $wheelMultiplier)', name: 'GameSocket');
    _socket?.emit('answer', {
      'roomId': roomId,
      'questionId': questionId,
      'answer': answer,
      'multiplier': multiplier,
      'wheelMultiplier': wheelMultiplier ?? 1,
    });
  }

  /// Sıralamayı iste
  void requestRanking(String roomId) {
    log('📊 Requesting ranking for room: $roomId', name: 'GameSocket');
    _socket?.emit('getRank', {'roomId': roomId});
  }

  /// Socket instance oluştur
  void _createSocket() {
  // /quiz namespace'ine bağlan (backend'de tanımlı)
  final String socketUrl = '${ApiConstants.baseUrl}/quiz';
    log('🌐 Creating socket connection to: $socketUrl', name: 'GameSocket');
    
    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // Add polling as fallback
          .disableAutoConnect()
          .enableReconnection()
          .setReconnectionAttempts(3)
          .setReconnectionDelay(2000)
          .setTimeout(10000) // Increase timeout to 10 seconds
          .setExtraHeaders({'Authorization': 'Bearer $_token'})
          .setQuery({'token': _token})
          .build(),
    );
    
    log('🔧 Socket configuration: timeout=10s, reconnect=3 attempts', name: 'GameSocket');
  }

  /// Event listener'ları kaydet
  void _registerEventListeners() {
    // Bağlantı event'leri
    _socket?.onConnect((_) {
      log('✅ Connected to game server (ID: ${_socket?.id})', name: 'GameSocket');
      log('🔗 Transport: ${_socket?.io.engine.transport?.name ?? 'unknown'}', name: 'GameSocket');
      _eventCallback?.call('connect', null);
    });

    _socket?.onDisconnect((reason) {
      log('❌ Disconnected: $reason', name: 'GameSocket');
      _eventCallback?.call('disconnect', reason);
    });

    _socket?.onConnectError((error) {
      log('⚠️ Connection error: $error', name: 'GameSocket');
      _eventCallback?.call('connectError', error);
    });

    _socket?.onError((error) {
      log('❌ Socket error: $error', name: 'GameSocket');
      _eventCallback?.call('error', error);
    });

    // Game event'leri
    _socket?.on(GameSocketEvents.timeLeft, (data) {
      log('⏰ Countdown: ${data}s', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.timeLeft, data);
    });

    _socket?.on(GameSocketEvents.intervalPing, (data) {
      log('❓ Question received: $data', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.intervalPing, data);
    });

    _socket?.on(GameSocketEvents.intervalTimeLeft, (data) {
      log('⏱️ Question timer: ${data}s', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.intervalTimeLeft, data);
    });

    _socket?.on(GameSocketEvents.roomStarted, (data) {
      log('🚀 Room started!', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.roomStarted, data);
    });

    _socket?.on(GameSocketEvents.roomReady, (data) {
      log('🎮 Room ready!', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.roomReady, data);
    });

    _socket?.on(GameSocketEvents.answerResult, (data) {
      log('🎯 Answer result received', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.answerResult, data);
    });

    _socket?.on(GameSocketEvents.score, (data) {
      log('🏆 Score update: $data', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.score, data);
    });

    _socket?.on(GameSocketEvents.rankResult, (data) {
      log('📊 Ranking received', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.rankResult, data);
    });

    _socket?.on(GameSocketEvents.joined, (data) {
      log('🎉 Successfully joined room: $data', name: 'GameSocket');
      _eventCallback?.call(GameSocketEvents.joined, data);
    });

    // Additional backend events (these are what we see in your logs)
    _socket?.on('hello', (data) {
      log('👋 Hello from server: $data', name: 'GameSocket');
      _eventCallback?.call('hello', data);
    });

    _socket?.on('userJoined', (data) {
      log('👤 User joined: $data', name: 'GameSocket');
      _eventCallback?.call('userJoined', data);
    });

    _socket?.on('userLeft', (data) {
      log('🚪 User left: $data', name: 'GameSocket');
      _eventCallback?.call('userLeft', data);
    });
  }
}