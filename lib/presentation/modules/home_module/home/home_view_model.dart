import 'dart:developer';

import 'package:bilbank_app/core/api_constants.dart';
import 'package:bilbank_app/data/apiService/api_service.dart';
import 'package:bilbank_app/data/apiService/api_service_impl.dart';
import 'package:bilbank_app/data/apiService/api_response.dart';
import 'package:bilbank_app/data/models/models/room_model.dart';
import 'package:bilbank_app/data/models/models/room_state.dart';
import 'package:bilbank_app/data/models/requests/room_request.dart';
import 'package:flutter/material.dart';

import '../../../../data/models/responses/notification_count_response.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({ApiService? api}) : _apiService = api ?? ApiServiceImpl();
  final ApiService _apiService;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  List<RoomModel> _rooms = [];
  List<RoomModel> get rooms => _rooms;

  bool _loadingRoomState = false;
  bool get loadingRoomState => _loadingRoomState;

  RoomState? _roomState;
  RoomState? get roomState => _roomState;

  int _notificationCount = 0;
  int get notificationCount => _notificationCount;

  Future<void> fetchRoomData() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _apiService.getRequest(ApiConstants.roomPath);
      final parsed = ApiResponse<List<RoomModel>>.fromJson(
        res.data as Map<String, dynamic>,
        (obj) => (obj as List)
            .map((e) => RoomModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

      if (parsed.isSuccess && parsed.data != null) {
        _rooms = parsed.data!;
      } else {
        _error = parsed.errorMessage ?? 'Bilinmeyen hata';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> showRoomDetails(String roomId) async {
    _loadingRoomState = true;
    _error = null;
    _roomState = null; // önceki sonucu temizle
    notifyListeners();

    try {
      final res = await _apiService.postRequest(
        ApiConstants.showRoomPath,
        RoomRequest(roomId: roomId),
      );

      final parsed = ApiResponse<RoomState>.fromJson(
        res.data as Map<String, dynamic>,
        (obj) => RoomState.fromJson(obj as Map<String, dynamic>),
      );

      if (parsed.isSuccess && parsed.data != null) {
        _roomState = parsed.data!;
      } else {
        _error = parsed.errorMessage ?? 'Bilinmeyen hata';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _loadingRoomState = false;
      notifyListeners();
    }
  }

  Future<bool> reserveRoom(String roomId) async {
    _loadingRoomState = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _apiService.postRequest(
        ApiConstants.reserveRoomPath,
        RoomRequest(roomId: roomId).toJson(), // << önemli
      );

      // ApiResponse<T> yapını kullanalım; sadece code bakacağız
      final parsed = ApiResponse<void>.fromJson(
        res.data as Map<String, dynamic>,
        (_) => null,
      );

      final success =
          parsed.isSuccess || parsed.code == 200 || parsed.code == 201 || parsed.code == 409;
      
      // 409 (ALREADY_RESERVED) hatası success olarak kabul et, hata mesajı gösterme
      if (!success) {
        _error = parsed.errorMessage ?? 'İşlem başarısız';
      } else if (parsed.code == 409) {
        _error = null; // Zaten rezervasyon var, bu bir hata değil
      }
      
      return success;
    } catch (e) {
      return false;
    } finally {
      _loadingRoomState = false;
      notifyListeners();
    }
  }

  Future<bool> joinRoom(String roomId) async {
    _loadingRoomState = true;
    _error = null;
    notifyListeners();
    try {
      final res = await _apiService.postRequest(
        ApiConstants.joinRoomPath,
        RoomRequest(roomId: roomId).toJson(), // << önemli
      );

      // ApiResponse<T> yapını kullanalım; sadece code bakacağız
      final parsed = ApiResponse<void>.fromJson(
        res.data as Map<String, dynamic>,
        (_) => null,
      );

      final success =
          parsed.isSuccess || parsed.code == 200 || parsed.code == 201;
      if (!success) _error = parsed.errorMessage ?? 'İşlem başarısız';
      return success;
    } catch (e) {
      return false;
    } finally {
      _loadingRoomState = false;
      notifyListeners();
    }
  }

  Future<void> fetchNotificationCount() async {
    // Bu fonksiyonu temporary olarak güvenli hale getiriyoruz
    try {
      final res = await _apiService.postRequest(
        ApiConstants.getNotificationCount,
        null,
      );

      final parsed = ApiResponse<NotificationCountResponse>.fromJson(
        res.data as Map<String, dynamic>,
        (obj) =>
            NotificationCountResponse.fromJson(obj as Map<String, dynamic>),
      );

      _notificationCount = parsed.data?.count ?? 0;
      log(_notificationCount.toString(), name: "notificationCount");
    } catch (e) {
      // Hata durumunda sadece log yazdır, hata fırlatma
      log('Notification count fetch error: $e', name: "notificationCountError");
      _notificationCount = 0; // Default değer ver
    }
    notifyListeners();
  }

  void clearNotificationCount() {
    _notificationCount = 0;
    notifyListeners();
  }

  // Future<RoomRewardsModel?> fetchRoomRewards(String roomId) async {
  //   // Backend hazır olduğunda bu metod kullanılacak
  //   try {
  //     final res = await _apiService.postRequest(
  //       ApiConstants.roomRewardsPath,
  //       {'room_id': roomId},
  //     );
  //
  //     final parsed = ApiResponse<RoomRewardsModel>.fromJson(
  //       res.data as Map<String, dynamic>,
  //       (obj) => RoomRewardsModel.fromJson(obj as Map<String, dynamic>),
  //     );
  //
  //     if (parsed.isSuccess && parsed.data != null) {
  //       return parsed.data!;
  //     }
  //   } catch (e) {
  //     log('Room rewards fetch error: $e');
  //   }
  //   return null;
  // }
}
