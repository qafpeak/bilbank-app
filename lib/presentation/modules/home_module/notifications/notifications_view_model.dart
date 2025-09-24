import 'package:bilbank_app/core/api_constants.dart';
import 'package:bilbank_app/data/apiService/api_service.dart';
import 'package:bilbank_app/data/apiService/api_service_impl.dart';
import 'package:bilbank_app/data/models/models/notification_model.dart';
import 'package:flutter/material.dart';

import '../../../../data/apiService/api_response.dart';

class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel({ApiService? api})
    : _apiService = api ?? ApiServiceImpl();
  final ApiService _apiService;

  bool _loading = false;
  bool get loading => _loading;

  bool _error = false;
  bool get error => _error;

  List<NotificationModel> _notifications = [];
  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotification() async {
    _loading = true;
    _error = false;

    try {
      final res = await _apiService.getRequest(ApiConstants.notificationPath);
      final parsed = ApiResponse<List<NotificationModel>>.fromJson(
        res.data as Map<String, dynamic>,
        (obj) => (obj as List)
            .map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
      if(parsed.isSuccess && parsed.data != null){
        _notifications = parsed.data!;
      }
      
    }catch(err){
      _error = true;
    }finally{
      _loading = false;
      notifyListeners();
    }
  }
}
