import 'dart:async';
import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';

class SpinWheelDialog extends StatefulWidget {
  const SpinWheelDialog({super.key});

  @override
  State<SpinWheelDialog> createState() => _SpinWheelDialogState();
}

class _SpinWheelDialogState extends State<SpinWheelDialog> {
  final List<int> _items = const [
    5,
    10,
    20,
    75,
    5,
    10,
    20,
    30,
    5,
    10,
    100,
    50,
    5,
    10,
    20,
    30,
  ];

  final Map<int, List<Color>> _valueGradientMap = const {
    5: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
    10: [Color(0xFF4ECDC4), Color(0xFF6BFFF2)],
    20: [Color(0xFF45B7D1), Color(0xFF96C93D)],
    30: [Color(0xFFFF9500), Color(0xFFFFB84D)],
    50: [Color(0xFF9B59B6), Color(0xFFBB6BD9)],
    75: [Color(0xFFE74C3C), Color(0xFFF39C12)],
    100: [Color(0xFFFFD700), Color(0xFFFFA500)],
  };

  final _selectedCtrl = StreamController<int>();
  final _confettiCtrl = ConfettiController(
    duration: const Duration(seconds: 2),
  );
  int? _lastIndex;

  @override
  void dispose() {
    _selectedCtrl.close();
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _spin() {
    final idx = Random().nextInt(_items.length);
    _lastIndex = idx;
    _selectedCtrl.add(idx);
  }

  List<Color> _gradientOf(int value) =>
      _valueGradientMap[value] ?? [Colors.grey, Colors.black];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360), // sabit genişlik
        child: Column(
          mainAxisSize: MainAxisSize.min, // içerik kadar yükseklik
          children: [
            // Wheel + Confetti sabit bir alan içinde (intrinsic yok!)
            SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  FortuneWheel(
                    selected: _selectedCtrl.stream,
                    animateFirst: false,
                    duration: const Duration(seconds: 3),
                    indicators: const [
                      FortuneIndicator(
                        alignment: Alignment.topCenter,
                        child: TriangleIndicator(
                          color: Colors.white,
                          width: 18,
                          height: 12,
                        ),
                      ),
                    ],
                    onAnimationEnd: () async {
                      final index = _lastIndex ?? 0;
                      _confettiCtrl.play();
                      await Future.delayed(const Duration(milliseconds: 900));
                      if (!mounted) return;
                      Navigator.of(context).pop(_items[index]);
                    },
                    items: List.generate(_items.length, (i) {
                      final value = _items[i];
                      final gradient = _gradientOf(value);
                      return FortuneItem(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: gradient,
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Align(
                            alignment: const Alignment(0.6, 0),
                            child: Text(
                              value.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 3,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        style: FortuneItemStyle(
                          color: Colors.transparent,
                          borderColor: Colors.white.withOpacity(0.8),
                          borderWidth: 1.5,
                        ),
                      );
                    }),
                  ),
                  // Confetti overlay
                  // Üst-Orta
                  Align(
                    alignment: Alignment.topCenter,
                    child: IgnorePointer(
                      child: ConfettiWidget(
                        confettiController: _confettiCtrl,
                        blastDirectionality: BlastDirectionality.explosive,
                        emissionFrequency: 0.02,
                        numberOfParticles: 20,
                        gravity: 0.15,
                      ),
                    ),
                  ),

                  // Sol-Alt (tek yönlü patlatma örneği)
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: IgnorePointer(
                      child: ConfettiWidget(
                        confettiController: _confettiCtrl,
                        // 0 rad = sağa, pi/2 = aşağı, pi = sola, 3pi/2 = yukarı
                        blastDirection: pi / 4, // sağ-alt çapraz
                        blastDirectionality: BlastDirectionality.directional,
                        emissionFrequency: 0.015,
                        numberOfParticles: 25,
                        gravity: 0.2,
                      ),
                    ),
                  ),

                  // Sağ-Alt
                  Align(
                    alignment: Alignment.bottomRight,
                    child: IgnorePointer(
                      child: ConfettiWidget(
                        confettiController: _confettiCtrl,
                        blastDirection: 3 * pi / 4, // sol-alt çapraz
                        blastDirectionality: BlastDirectionality.directional,
                        emissionFrequency: 0.015,
                        numberOfParticles: 25,
                        gravity: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _spin, child: const Text("🎯 ÇEVİR")),
          ],
        ),
      ),
    );
  }
}