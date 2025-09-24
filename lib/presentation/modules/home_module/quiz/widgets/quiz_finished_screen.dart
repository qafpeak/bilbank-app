import 'package:flutter/material.dart';

import '../quiz_constants.dart';

class QuizFinishedScreen extends StatelessWidget {
  const QuizFinishedScreen({
    super.key,
    required this.score,
    required this.rank,
    required this.onPlayAgain,
    required this.onReturnHome,
  });

  final int score;
  final int rank;
  final VoidCallback onPlayAgain;
  final VoidCallback onReturnHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.emoji_events,
              size: 60,
              color: Colors.amber,
            ),
            const SizedBox(height: 16),
            const Text(
              'Oyun Bitti!',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: quizPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    'Final Skorunuz',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$score',
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: quizPrimaryColor,
                    ),
                  ),
                  if (rank > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Sıralama: #$rank',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onPlayAgain,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tekrar Oyna'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: quizPrimaryColor.withOpacity(0.2),
                      foregroundColor: quizPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onReturnHome,
                    icon: const Icon(Icons.home),
                    label: const Text('Ana Sayfa'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: quizPrimaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
