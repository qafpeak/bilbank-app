import 'package:flutter/material.dart';

import 'wheel_widgets.dart';

class QuizHeader extends StatelessWidget {
  const QuizHeader({
    super.key,
    required this.roomId,
    required this.score,
    required this.isSocketConnected,
    required this.wheelBalance,
    required this.isWheelSpinning,
    this.onBack,
    this.onRankingTap,
    this.onWheelTap,
  });

  final String roomId;
  final int score;
  final bool isSocketConnected;
  final int wheelBalance;
  final bool isWheelSpinning;
  final VoidCallback? onBack;
  final VoidCallback? onRankingTap;
  final VoidCallback? onWheelTap;

  @override
  Widget build(BuildContext context) {
    final bool canSpinWheel = onWheelTap != null;

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Quiz Oyunu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Oda: $roomId',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              if (score > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Skor: $score',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: onRankingTap,
                icon: const Icon(
                  Icons.leaderboard,
                  color: Colors.white,
                  size: 24,
                ),
                tooltip: 'Sıralama',
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              GestureDetector(
                onTap: canSpinWheel ? onWheelTap : null,
                child: AnimatedRotation(
                  turns: isWheelSpinning ? 5 : 0,
                  duration: const Duration(seconds: 5),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(
                        isWheelSpinning ? 0.3 : 0.15,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isWheelSpinning
                          ? [
                              BoxShadow(
                                color: Colors.amber.withOpacity(0.4),
                                blurRadius: 12,
                                spreadRadius: 2,
                              ),
                            ]
                          : [],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        WheelWidget(
                          isSpinning: isWheelSpinning,
                          size: 40,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Çark: $wheelBalance/15',
                          style: TextStyle(
                            color: isWheelSpinning
                                ? Colors.amber
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        if (isWheelSpinning)
                          const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.amber,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                isSocketConnected ? Icons.wifi : Icons.wifi_off,
                color: isSocketConnected ? Colors.greenAccent : Colors.redAccent,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                isSocketConnected ? 'Bağlı' : 'Bağlanıyor...',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
