import 'package:bilbank_app/data/models/models/room_state.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_view.dart';
import 'package:bilbank_app/presentation/modules/home_module/home/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

mixin HomeViewMixin on State<HomeView> {
  late HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = Provider.of<HomeViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await viewModel.fetchRoomData();
      await viewModel.fetchNotificationCount();
    });
  }

  Future<T?> showRoomStateBottomSheet<T>({
    required BuildContext context,
    required RoomState room,
    required bool isLoading,
    VoidCallback? onPrimary,
    VoidCallback? onJoin,
  });

  void showResultSnack(BuildContext context, {required bool ok, String? error});
}


