import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/utils/string_formatter.dart';
import 'stat_card_actions.dart';

class StatCard extends StatelessWidget {
  final List<Color> gradient;
  final Color shadowColor;
  final String iconAsset;
  final int targetValue;
  final String buttonText;
  final VoidCallback onButtonTap;
  final VoidCallback onRefresh;

  const StatCard({
    Key? key,
    required this.gradient,
    required this.shadowColor,
    required this.iconAsset,
    required this.targetValue,
    required this.buttonText,
    required this.onButtonTap,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 20, left: 20, bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgPicture.asset(iconAsset, width: 28, height: 28),
              const SizedBox(width: 6),
              Text(
                formatNumber(targetValue),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          StatCardActions(
            onShopTap: onButtonTap,
            onRefreshTap: onRefresh,
          ),
        ],
      ),
    );
  }
}
