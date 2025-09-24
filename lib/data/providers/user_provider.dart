import 'package:flutter/material.dart';
import 'package:bilbank_app/data/apiService/api_service.dart';
import 'package:bilbank_app/data/apiService/api_service_impl.dart';
import 'package:bilbank_app/core/api_constants.dart';
import 'package:bilbank_app/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_app/data/local_storage/local_storage_keys.dart';
import 'package:bilbank_app/data/models/models/avatar_model.dart';

class UserProvider extends ChangeNotifier {
  Future<void> loadUserInfoFromLocal() async {
    print('🔍 loadUserInfoFromLocal başladı');
    // SharedPreferences erişimi için LocalStorageImpl kullanılıyor
    final localStorage = LocalStorageImpl();
    _firstName = await localStorage.getValue<String>(LocalStorageKeys.firstName, '');
    _lastName = await localStorage.getValue<String>(LocalStorageKeys.lastName, '');
    _username = await localStorage.getValue<String>(LocalStorageKeys.userName, '');
    _email = await localStorage.getValue<String>(LocalStorageKeys.userEmail, '');
    _balance = await localStorage.getValue<double>(LocalStorageKeys.userBalance, 0.0);
    _trivaBalance = await localStorage.getValue<double>(LocalStorageKeys.userTrivaBalance, 0.0);
    _avatarId = await localStorage.getValue<String>(LocalStorageKeys.userAvatarId, '1');
    
    print('🔍 LocalStorage\'dan okunan veriler:');
    print('🔍 First Name: $_firstName');
    print('🔍 Last Name: $_lastName');
    print('🔍 Username: $_username');
    print('🔍 Email: $_email');
    
    notifyListeners();
  }
  double _balance = 0;
  double get balance => _balance;

  double _trivaBalance = 0;
  double get trivaBalance => _trivaBalance;

  String? _firstName;
  String? _lastName;
  String? _username;
  String? _email;
  String? _avatarId;

  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get username => _username;
  String? get email => _email;
  String? get avatarId => _avatarId;

  final ApiService _apiService = ApiServiceImpl();

  // Kullanıcı profilini backend'den çek ve local storage'a kaydet
  Future<bool> fetchUserProfile() async {
    try {
      print('🔍 fetchUserProfile başladı');
      final res = await _apiService.getRequest(ApiConstants.getUserProfile);
      print('🔍 API Response: ${res.data}');
      
      if (res.data != null) {
        // Backend response yapısı: {code: 200, data: {user_data...}}
        final responseData = res.data;
        final userData = responseData['data']; // İç içe geçmiş data alanına erişim
        print('🔍 User Data: $userData');
        
        if (userData != null) {
          // Local storage'a kaydet
          final localStorage = LocalStorageImpl();
          await localStorage.setValue<String>(LocalStorageKeys.firstName, userData['first_name'] ?? '');
          await localStorage.setValue<String>(LocalStorageKeys.lastName, userData['last_name'] ?? '');
          await localStorage.setValue<String>(LocalStorageKeys.userName, userData['username'] ?? '');
          await localStorage.setValue<String>(LocalStorageKeys.userEmail, userData['email'] ?? '');
          await localStorage.setValue<String>(LocalStorageKeys.userId, userData['id'] ?? '');
          await localStorage.setValue<double>(LocalStorageKeys.userBalance, (userData['balance'] as num?)?.toDouble() ?? 0.0);
          await localStorage.setValue<double>(LocalStorageKeys.userTrivaBalance, (userData['triva'] as num?)?.toDouble() ?? 0.0);
          await localStorage.setValue<String>(LocalStorageKeys.userAvatarId, userData['avatar']?.toString() ?? '1');
          
          print('🔍 LocalStorage\'a kaydedildi');
          
          // Provider'da da güncelle
          _firstName = userData['first_name'] ?? '';
          _lastName = userData['last_name'] ?? '';
          _username = userData['username'] ?? '';
          _email = userData['email'] ?? '';
          _balance = (userData['balance'] as num?)?.toDouble() ?? 0.0;
          _trivaBalance = (userData['triva'] as num?)?.toDouble() ?? 0.0;
          _avatarId = userData['avatar']?.toString() ?? '1';
          
          print('🔍 Provider güncellendi: $_firstName $_lastName, $_username, $_email');
          
          notifyListeners();
          return true;
        }
      }
      print('🔍 Response data null');
      return false;
    } catch (e) {
      // Hata yönetimi
      print('❌ Error fetching user profile: $e');
      return false;
    }
  }

  // Kullanıcı bilgilerini güncelle
  void setUserInfo({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required double balance,
    double trivaBalance = 0.0,
    String? avatarId,
  }) {
    _firstName = firstName;
    _lastName = lastName;
    _username = username;
    _email = email;
    _balance = balance;
    _trivaBalance = trivaBalance;
    if (avatarId != null) _avatarId = avatarId;
    notifyListeners();
  }

  Future<void> fetchBalance(String userId) async {
    try {
      final res = await _apiService.getRequest('${ApiConstants.apiPath}/admin/getUserBalance/$userId');
      if (res.data != null && res.data['balance'] != null) {
        _balance = (res.data['balance'] as num).toDouble();
        notifyListeners();
      }
    } catch (e) {
      // Hata yönetimi
    }
  }

  void setBalance(double value) {
    _balance = value;
    notifyListeners();
  }

  void setTrivaBalance(double value) {
    _trivaBalance = value;
    notifyListeners();
  }

  // Kullanıcının güncel bakiye bilgilerini backend'den çek
  Future<void> refreshUserBalances() async {
    try {
      print('🔍 refreshUserBalances başladı');
      final res = await _apiService.getRequest(ApiConstants.getUserProfile);
      print('🔍 Balance API Response: ${res.data}');
      
      if (res.data != null) {
        final responseData = res.data;
        final userData = responseData['data'];
        
        if (userData != null) {
          // Sadece bakiye bilgilerini güncelle
          _balance = (userData['balance'] as num?)?.toDouble() ?? 0.0;
          _trivaBalance = (userData['triva'] as num?)?.toDouble() ?? 0.0;
          
          // Local storage'a da kaydet
          final localStorage = LocalStorageImpl();
          await localStorage.setValue<double>(LocalStorageKeys.userBalance, _balance);
          await localStorage.setValue<double>(LocalStorageKeys.userTrivaBalance, _trivaBalance);
          
          print('🔍 Bakiyeler güncellendi: Elmas=$_balance, Çark=$_trivaBalance');
          notifyListeners();
        }
      }
    } catch (e) {
      print('❌ Error refreshing user balances: $e');
    }
  }

  // Avatar ilgili metodlar
  Future<List<AvatarModel>> fetchAvatarList() async {
    try {
      print('🔍 fetchAvatarList başladı');
      final res = await _apiService.getRequest(ApiConstants.getAvatarList);
      print('🔍 Avatar List API Response: ${res.data}');
      
      if (res.data != null) {
        final responseData = res.data;
        final avatarData = responseData['data'];
        
        if (avatarData != null) {
          final avatarResponse = AvatarListResponse.fromJson(avatarData);
          return avatarResponse.avatars;
        }
      }
      
      // API hatası durumunda varsayılan liste döndür
      return _getDefaultAvatarList();
    } catch (e) {
      print('❌ Error fetching avatar list: $e');
      // Hata durumunda varsayılan liste döndür
      return _getDefaultAvatarList();
    }
  }

  // Avatar güncelle
  Future<bool> updateAvatar(String avatarId) async {
    try {
      print('🔍 updateAvatar başladı: $avatarId');
      final res = await _apiService.postRequest(
        ApiConstants.updateUserAvatar,
        {'avatar_id': avatarId},
      );
      print('🔍 Update Avatar API Response: ${res.data}');
      
      if (res.data != null) {
        final responseData = res.data;
        
        if (responseData['success'] == true || responseData['code'] == 200) {
          // Local storage'ı güncelle
          final localStorage = LocalStorageImpl();
          await localStorage.setValue<String>(LocalStorageKeys.userAvatarId, avatarId);
          
          // Provider'ı güncelle
          _avatarId = avatarId;
          notifyListeners();
          
          print('🔍 Avatar güncellendi: $avatarId');
          return true;
        }
      }
      return false;
    } catch (e) {
      print('❌ Error updating avatar: $e');
      return false;
    }
  }

  // Avatar URL'ini oluştur
  String getAvatarUrl(String? avatarId) {
    final id = avatarId ?? _avatarId ?? '1';
    return '${ApiConstants.baseUrl}/assets/pp/pp$id.png';
  }

  // Varsayılan avatar listesi (backend erişilemediğinde)
  List<AvatarModel> _getDefaultAvatarList() {
    return AvatarListResponse.createDefaultAvatars(
      baseUrl: ApiConstants.baseUrl,
      currentAvatarId: _avatarId,
    ).avatars;
  }
}
