import 'dart:developer';

import 'package:bilbank_app/core/api_constants.dart';
import 'package:bilbank_app/data/apiService/api_response.dart';
import 'package:bilbank_app/data/apiService/api_service.dart';
import 'package:bilbank_app/data/apiService/api_service_impl.dart';
import 'package:bilbank_app/data/models/requests/login_register_request.dart';
import 'package:flutter/material.dart';

class RegisterAccountViewModel extends ChangeNotifier {
  final ApiService apiService = ApiServiceImpl();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ApiResponse? _registerResponse;
  ApiResponse? get registerResponse => _registerResponse;

  Future<void> registerAccount(LoginRegisterRequest request) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await apiService.postPublic(
        ApiConstants.registerUserAccount,
        request.toJson(),
      );

      _registerResponse = ApiResponse.fromJson(response.data, null);

      if (_registerResponse?.isSuccess == true) {
        log('✅ RegisterAccount Success: ${_registerResponse?.data}');
      } else {
        log('❌ RegisterAccount Failed: ${_registerResponse?.errorMessage}');
      }
    } catch (e) {
      // Burada da ApiResponse’a sarıyoruz
      _registerResponse = ApiResponse(
        code: -1, // kendi belirlediğin "beklenmeyen hata kodu"
        error: ApiError(
          message: "İstek sırasında hata oluştu",
          description: e.toString(),
        ),
      );

      log('❌ RegisterAccount Exception: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearRegisterResponse() {
    _registerResponse = null;
  }
}
