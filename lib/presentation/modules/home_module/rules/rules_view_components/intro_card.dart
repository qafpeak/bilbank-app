import 'package:flutter/material.dart';

class IntroCard extends StatelessWidget {
  const IntroCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.purple.shade900],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hoş Geldiniz!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Bilbank, bilgi sorularını doğru cevaplayarak puan toplayıp ödül kazandığınız ve bu ödülleri çekim talebi ile nakite çevirebileceğiniz bir bilgi yarışması oyunudur. Cevaplar yalnızca “Evet” veya “Hayır” olabilir. Aşağıda tüm kurallar detaylı olarak açıklanmıştır.",
            style: TextStyle(color: Colors.white70, height: 1.5),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
