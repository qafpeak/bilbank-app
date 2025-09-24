import 'package:flutter/material.dart';

class EarningMethod {
  final String id;
  final String title;
  final String icon;
  final int reward;
  final String? rewardRange;
  final List<Color> gradient;
  final bool hasTimer;
  final bool hasProgress;
  final double progress;
  final bool isCompleted;

  EarningMethod({
    required this.id,
    required this.title,
    required this.icon,
    required this.reward,
    this.rewardRange,
    required this.gradient,
    this.hasTimer = false,
    this.hasProgress = false,
    this.progress = 0.0,
    this.isCompleted = false,
  });
}