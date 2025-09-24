import 'package:flutter/material.dart';

import '../quiz_constants.dart';

class QuizWaitingScreen extends StatelessWidget {
  const QuizWaitingScreen({
    super.key,
    required this.isSocketConnected,
    required this.onRetryConnection,
  });

  final bool isSocketConnected;
  final VoidCallback onRetryConnection;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSocketConnected ? Icons.wifi : Icons.wifi_off,
            color: isSocketConnected ? Colors.green : Colors.red,
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            isSocketConnected ? 'Bağlantı Kuruldu' : 'Bağlantı Bekleniyor...',
            style: TextStyle(
              color: isSocketConnected ? Colors.green : Colors.orange,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          const Text(
            'Oyun başlaması bekleniyor...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Minimum katılımcı sayısı sağlandığında oyun başlayacak',
            style: TextStyle(
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (!isSocketConnected)
            ElevatedButton.icon(
              onPressed: onRetryConnection,
              icon: const Icon(Icons.refresh),
              label: const Text('Bağlantıyı Yenile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: quizPrimaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
