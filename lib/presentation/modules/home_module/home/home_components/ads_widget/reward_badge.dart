import 'package:flutter/material.dart';

class RewardBadge extends StatelessWidget {
  final int reward;
  final String? rewardRange;

  const RewardBadge({
    Key? key,
    required this.reward,
    this.rewardRange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFffeaa7), Color(0xFFfdcb6e)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Color(0xFFfdcb6e).withOpacity(0.4),
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        rewardRange != null ? '+$rewardRange 💎' : '+$reward 💎',
        style: TextStyle(
          color: Color(0xFF2d3436),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
