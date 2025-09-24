import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:bilbank_app/core/api_constants.dart';

class QuizSocketService {
  static final QuizSocketService _instance = QuizSocketService._internal();
  factory QuizSocketService() => _instance;
  QuizSocketService._internal();

  IO.Socket? _socket;
  String? _token;

  Function(String event, dynamic data)? _notifierCallback;

  void setNotifierCallback(Function(String, dynamic) callback) {
    _notifierCallback = callback;
  }

  /// Bağlı olup olmadığını kontrol et
  bool get isConnected => _socket?.connected ?? false;

  /// Socket'i başlat
  void initSocket({required String token}) {
    _token = token;
    log('🔧 Initializing socket with token: ${token.substring(0, 20)}...', name: 'SocketService');

    if (_socket != null && _socket!.connected) {
      log('🔄 Socket already connected, skipping init', name: 'SocketService');
      return;
    }

    final socketUrl = '${ApiConstants.baseUrl}/quiz';
    log('🌐 Creating socket connection to $socketUrl', name: 'SocketService');
    _socket = IO.io(
      socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // websocket + fallback
          .disableAutoConnect() // manuel connect
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(2000)
          .setTimeout(10000)
          .setExtraHeaders({'Authorization': 'Bearer $_token'}) // header token
          .setQuery({'token': _token}) // query token
          .build(),
    );

    log('📡 Socket instance created, registering listeners...', name: 'SocketService');
    _registerListeners();
    log('✅ Socket initialization completed', name: 'SocketService');
  }

  /// Socket bağlantısını başlat
  void connect() {
    log('🔌 Attempting to connect socket...', name: 'SocketService');
    _socket?.connect();
  }

  /// Bağlantıyı kes
  void disconnect() {
    _socket?.disconnect();
  }

  /// Odaya katıl
  void joinRoom(String roomId) {
    log('🚪 Emitting joinRoom for: $roomId', name: 'SocketService');
    log('🔌 Socket connected: ${isConnected}', name: 'SocketService');
    _socket?.emit('joinRoom', {'roomId': roomId});
  }

  /// Odadan çık
  void leaveRoom(String roomId) {
    _socket?.emit('leaveRoom', {'roomId': roomId});
  }

  /// Odayı başlat (admin/test için)
  void startRoom(String roomId, {Map<String, dynamic>? meta}) {
    _socket?.emit('startRoom', {'roomId': roomId, 'meta': meta ?? {}});
  }

  /// Odayı bitir (admin/test için)
  void endRoom(String roomId, {String reason = 'finished'}) {
    _socket?.emit('endRoom', {'roomId': roomId, 'reason': reason});
  }

  void answer(String roomId, String questionId,bool answer,int wheelMultiplier) {
    _socket?.emit('answer', {'roomId': roomId,'questionId': questionId, 'answer': answer,'wheelMultiplier':wheelMultiplier});
  }

  void getRank(String roomId) {
    _socket?.emit('getRank', {'roomId': roomId});

    _socket?.on('rankResult', (data) {
      log('🔥 Rank Result: $data', name: 'SocketEvent.rankResult');
      _notifierCallback?.call('rankResult', data);
    });
  }


  void _registerListeners() {
    _socket?.onConnect((_) {
      log('✅ Socket connected: ${_socket?.id}', name: 'SocketService');
      log('🔌 Connected to namespace: /quiz', name: 'SocketService');
      try {
        log('🔗 Socket transport: ${_socket?.io.engine.transport?.name ?? 'unknown'}', name: 'SocketService');
      } catch (e) {
        log('🔗 Transport info unavailable: $e', name: 'SocketService');
      }
    });

    _socket?.onDisconnect((reason) {
      log('❌ Socket disconnected: $reason', name: 'SocketService');
    });

    _socket?.onConnectError((error) {
      log('⚠️ Connect error: $error', name: 'SocketService');
    });

    _socket?.onError((error) {
      log('❌ Socket error: $error', name: 'SocketService');
    });

    // --- Sunucudan gelen event'ler ---
    _socket?.on('hello', (data) {
      log('👋 Hello: $data', name: 'SocketEvent.hello');
      _notifierCallback?.call('hello', data);
    });

    _socket?.on('joined', (data) {
      log('🎉 Joined room successfully: $data', name: 'SocketEvent.joined');
      _notifierCallback?.call('joined', data);
    });

    _socket?.on('left', (data) {
      log('👋 Left room: $data', name: 'SocketEvent.left');
      _notifierCallback?.call('left', data);
    });

    _socket?.on('userJoined', (data) {
      log('👤 User joined: $data', name: 'SocketEvent.userJoined');
      _notifierCallback?.call('userJoined', data);
    });

    _socket?.on('userLeft', (data) {
      log('🚪 User left: $data', name: 'SocketEvent.userLeft');
      _notifierCallback?.call('userLeft', data);
    });

    _socket?.on('roomStarted', (data) {
      log('🚀 Room started: $data', name: 'SocketEvent.roomStarted');
      _notifierCallback?.call('roomStarted', data);
    });

    _socket?.on('roomReady', (data) {
      log('🎮 Room ready: $data', name: 'SocketEvent.roomReady');
      _notifierCallback?.call('roomReady', data);
    });

    _socket?.on('intervalTimeLeft', (data) {
      log('⏱️ Interval Time Left: $data (type: ${data.runtimeType})', name: 'SocketEvent.intervalTimeLeft');
      _notifierCallback?.call('intervalTimeLeft', data);
    });

    _socket?.on('intervalPing', (data) {
      log('📝 Interval ping (QUESTION): $data (type: ${data.runtimeType})', name: 'SocketEvent.intervalPing');
      _notifierCallback?.call('intervalPing', data);
    });

    _socket?.on('started', (data) {
      log('🔥 Room is already running: $data', name: 'SocketEvent.started');
      _notifierCallback?.call('started', data);
    });

    _socket?.on('timeLeft', (data) {
      log('⏰ Time Left (COUNTDOWN): $data (type: ${data.runtimeType})', name: 'SocketEvent.timeLeft');
      _notifierCallback?.call('timeLeft', data);
    });

    _socket?.on('answerResult', (data) {
      log('🎯 Answer Result: $data', name: 'SocketEvent.answerResult');
      _notifierCallback?.call('answerResult', data);
    });

    _socket?.on('score', (data) {
      log('🏆 Score: $data', name: 'SocketEvent.score');
      _notifierCallback?.call('score', data);
    });

    _socket?.on('rankResult', (data) {
      log('� Rank Result: $data', name: 'SocketEvent.rankResult');
      _notifierCallback?.call('rankResult', data);
    });

  }
}
