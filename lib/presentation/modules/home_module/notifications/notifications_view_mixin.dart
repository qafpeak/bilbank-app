

import 'package:bilbank_app/presentation/modules/home_module/notifications/notifications_view.dart';
import 'package:bilbank_app/presentation/modules/home_module/notifications/notifications_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin NotificationsViewMixin on State<NotificationsView>{
  late NotificationsViewModel vm;


  @override 
  void initState() {
    super.initState();
    vm = context.read<NotificationsViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await vm.fetchNotification();
    });
   
  }
}
