

import 'package:bilbank_app/data/local_storage/local_storage.dart';
import 'package:bilbank_app/data/local_storage/local_storage_impl.dart';
import 'package:bilbank_app/data/local_storage/local_storage_keys.dart';
import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  LocalStorage localStorage = LocalStorageImpl();







  void logout() {
    localStorage.remove(LocalStorageKeys.rememberMeEmail);
    localStorage.remove(LocalStorageKeys.rememberMePassword);
    localStorage.remove(LocalStorageKeys.accessToken);
    localStorage.remove(LocalStorageKeys.rememberCheck);
  }

}


