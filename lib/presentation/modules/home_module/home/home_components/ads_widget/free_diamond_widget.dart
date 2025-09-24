// models/earning_method.dart

import 'package:bilbank_app/presentation/modules/home_module/home/home_components/ads_widget/footer_tip.dart' show FooterTip;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'earning_method_list.dart';
import 'earning_methods_service.dart';
import 'stat_card.dart';

class FreeDiamondsWidget extends StatefulWidget {
  final Function(String)? onMethodTap;
  final VoidCallback refreshCurrentDiamonds;
  final VoidCallback refreshCurrentWhells;
  final bool isFollow;
  final int initialDiamonds;
  final int initialWhells;

  const FreeDiamondsWidget({
    this.onMethodTap,
    required this.refreshCurrentDiamonds,
    required this.refreshCurrentWhells,
    this.initialDiamonds = 100000000,
    this.initialWhells = 15,
    this.isFollow = false,
  });

  @override
  State<FreeDiamondsWidget> createState() => _FreeDiamondsWidgetState();
}

class _FreeDiamondsWidgetState extends State<FreeDiamondsWidget> {

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 400),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDiamondsCard(),
          _buildWheelCard(),
          _buildEarningMethods(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildDiamondsCard() {
    return StatCard(
      gradient: const [Color(0xFFf093fb), Color(0xFFf5576c)],
      shadowColor: const Color(0xFFf093fb),
      iconAsset: 'assets/svg/ic_diamond.svg',
      targetValue: widget.initialDiamonds,
      buttonText: 'Satın Al',
      onButtonTap: () => context.go(""),
      onRefresh: widget.refreshCurrentDiamonds,
    );
  }

  Widget _buildWheelCard() {
    return StatCard(
      gradient: const [Color(0xFFFFA726), Color(0xFFFF7043)],
      shadowColor: const Color(0xFFFFA726),
      iconAsset: 'assets/svg/ic_wheel_lucky.svg',
      targetValue: widget.initialWhells,
      buttonText: 'Satın Al',
      onButtonTap: () => context.go(""),
      onRefresh: widget.refreshCurrentWhells,
    );
  }

  Widget _buildEarningMethods() {
    return EarningMethodsList(
      methods: EarningMethodsService.getEarningMethods(isFollow: widget.isFollow),
      onMethodTap: (methodId) => widget.onMethodTap?.call(methodId),
      isFollow: widget.isFollow,
    );
  }

  Widget _buildFooter() {
    return FooterTip(
      message: '💡 İpucu: Günlük olarak giriş yap ve daha fazla elmas kazan!',
    );
  }


}