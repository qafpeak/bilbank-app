import 'package:flutter/material.dart';
import '../models/quiz_models.dart';
import 'wheel_widgets.dart';

/// Soru gösterme widget'ı
class QuestionWidget extends StatelessWidget {
  final QuestionData question;
  final int timeLeft;
  final bool answerSent;
  final int wheelBalance;
  final VoidCallback? onYesTap;
  final VoidCallback? onNoTap;
  final VoidCallback? onWheelTap;
  final bool isWheelSpinning;
  final int? wheelMultiplierBadge;
  final bool showMultiplierInfo;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.timeLeft,
    this.answerSent = false,
    required this.wheelBalance,
    this.onYesTap,
    this.onNoTap,
    this.onWheelTap,
    this.isWheelSpinning = false,
    this.wheelMultiplierBadge,
    this.showMultiplierInfo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Üst kısım - Timer ve Multiplier
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Multiplier badge
                if (question.multiplier > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'x${question.multiplier}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(),
                // Timer
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 6,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
                      ),
                      CircularProgressIndicator(
                        value: timeLeft / 15.0,
                        strokeWidth: 6,
                        backgroundColor: Colors.transparent,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          timeLeft / 15.0 > 0.5 ? Colors.green : 
                          timeLeft / 15.0 > 0.2 ? Colors.orange : Colors.red,
                        ),
                      ),
                      Text(
                        '$timeLeft',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: timeLeft / 15.0 > 0.2 ? Colors.black87 : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Soru kartı
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.quiz,
                        size: 30,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      question.question,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            // Cevap butonları
            if (!answerSent && timeLeft > 0) ...[
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onNoTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'HAYIR',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onYesTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'EVET',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showMultiplierInfo)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Çarpan Bizden',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
        // Animasyonlu wheelMultiplierBadge
        if (wheelMultiplierBadge != null)
          Positioned(
            top: 8,
            right: 16,
            child: _AnimatedMultiplierBadge(multiplier: wheelMultiplierBadge!),
          ),
      ],
    );
  }

}

class _AnimatedMultiplierBadge extends StatefulWidget {
  final int multiplier;
  const _AnimatedMultiplierBadge({Key? key, required this.multiplier}) : super(key: key);

  @override
  State<_AnimatedMultiplierBadge> createState() => _AnimatedMultiplierBadgeState();
}

class _AnimatedMultiplierBadgeState extends State<_AnimatedMultiplierBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.2).chain(CurveTween(curve: Curves.easeOut)), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.2, end: 1.0).chain(CurveTween(curve: Curves.elasticOut)), weight: 50),
    ]).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (widget.multiplier) {
      case 10:
        color = const Color(0xFF4CAF50);
        break;
      case 25:
        color = const Color(0xFF2196F3);
        break;
      case 50:
        color = const Color(0xFF9C27B0);
        break;
      case 75:
        color = const Color(0xFFFF9800);
        break;
      case 100:
        color = const Color(0xFFFFD700);
        break;
      default:
        color = Colors.orange;
    }
    return ScaleTransition(
      scale: _scaleAnim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.5),
              blurRadius: 16,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star, color: Colors.white, size: 28),
            const SizedBox(width: 8),
            Text(
              'x${widget.multiplier}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 26,
                shadows: [
                  Shadow(color: Colors.black26, blurRadius: 6, offset: Offset(1, 2)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}