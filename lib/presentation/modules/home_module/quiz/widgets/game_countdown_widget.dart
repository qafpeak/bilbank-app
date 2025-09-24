import 'package:flutter/material.dart';

/// Oyun başlama countdown'u widget'ı
class GameCountdownWidget extends StatelessWidget {
  final int seconds;
  final String? roomName;

  const GameCountdownWidget({
    super.key,
    required this.seconds,
    this.roomName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Büyük countdown sayısı
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                '$seconds',
                style: theme.textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 48,
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Başlık
          Text(
            'Oyun Başlıyor!',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Oda adı (varsa)
          if (roomName != null)
            Text(
              roomName!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          
          const SizedBox(height: 16),
          
          // Açıklama
          Text(
            'Sorular gelmeye başladığında hızlıca cevap verin!',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // İlerleme çubuğu
          LinearProgressIndicator(
            value: seconds > 0 ? (30 - seconds) / 30 : 1.0,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 4,
          ),
        ],
      ),
    );
  }
}