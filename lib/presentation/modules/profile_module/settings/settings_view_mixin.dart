

import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view.dart';
import 'package:bilbank_app/presentation/modules/profile_module/settings/settings_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

mixin SettingsViewMixin on State<SettingsView>{

  late SettingsViewModel _vm;
  SettingsViewModel get vm => _vm;


  bool _adsHidden = false;
  bool get adsHidden=>_adsHidden;
  set adsHidden(bool value){
    setState(() {
      _adsHidden=value;
    });
  }

  // Satın alma işlemini gerçekleştiren method
  void processPurchase() {
    // Burada gerçek satın alma işlemi yapılacak
    // Örneğin: in-app purchase, API çağrısı vs.
    
    Navigator.of(context).pop(); // Bottom sheet'i kapat
    
    // Başarılı satın alma işlemi simülasyonu
    setState(() {
      adsHidden = true; // Switch'i aktif yap
    });
    
    // Başarılı satın alma mesajı göster
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Satın alma işlemi başarılı! Reklamlar gizlendi.'),
        backgroundColor: Colors.green,
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _vm = context.read<SettingsViewModel>();
  }

  void logout() {
    _vm.logout();
    context.go(AppPageKeys.login);
  }





  void showPurchaseBottomSheet();
}



