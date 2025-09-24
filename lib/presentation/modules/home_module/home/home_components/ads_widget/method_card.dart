import 'package:flutter/material.dart';

import 'earning_item_model.dart';
import 'reward_badge.dart';

class MethodCard extends StatelessWidget {
  final EarningMethod method;
  final VoidCallback onTap;
  final bool isPulsing;
  final Animation<double>? pulseAnimation;

  const MethodCard({
    Key? key,
    required this.method,
    required this.onTap,
    this.isPulsing = false,
    this.pulseAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget card = GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            MethodIcon(
              icon: method.icon,
              gradient: method.gradient,
            ),
            SizedBox(width: 15),
            Expanded(
              child: Text(
                method.title,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF333333),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            RewardBadge(
              reward: method.reward,
              rewardRange: method.rewardRange,
            ),
          ],
        ),
      ),
    );

    if (isPulsing && pulseAnimation != null) {
      return AnimatedBuilder(
        animation: pulseAnimation!,
        builder: (context, child) {
          return Transform.scale(
            scale: pulseAnimation!.value,
            child: card,
          );
        },
      );
    }

    return card;
  }
}


class MethodIcon extends StatelessWidget {
  final String icon;
  final List<Color> gradient;

  const MethodIcon({
    Key? key,
    required this.icon,
    required this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(icon, style: TextStyle(fontSize: 30)),
      ),
    );
  }
}