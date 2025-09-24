import 'package:flutter/material.dart';

import '../models/quiz_models.dart';

Future<void> showQuizRankingDialog({
  required BuildContext context,
  required RankingData rankingData,
  VoidCallback? onDialogDismissed,
}) async {
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => QuizRankingDialog(
      rankingData: rankingData,
    ),
  );

  onDialogDismissed?.call();
}

class QuizRankingDialog extends StatelessWidget {
  const QuizRankingDialog({
    super.key,
    required this.rankingData,
  });

  final RankingData rankingData;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '🏆 Sıralama',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            if (rankingData.myRank != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  rankingData.myRank!.displayText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 16),
            const Text(
              'İlk 10 Sıralama',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: rankingData.rankings.length,
                itemBuilder: (context, index) {
                  final item = rankingData.rankings[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item.isMe
                          ? Colors.yellow.withOpacity(0.3)
                          : Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: item.isMe
                          ? Border.all(color: Colors.yellow, width: 2)
                          : null,
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _rankColor(item.rank),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child: Text(
                              '${item.rank}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            item.username,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: item.isMe
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                        Text(
                          '${item.score} puan',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: item.isMe
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Color _rankColor(int rank) {
  switch (rank) {
    case 1:
      return Colors.amber;
    case 2:
      return Colors.grey[300]!;
    case 3:
      return Colors.orange[300]!;
    default:
      return Colors.blue[300]!;
  }
}
