import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';

class FortuneWheelWidget extends StatefulWidget {
  final Function(int) onResult;
  final bool isSpinning;
  const FortuneWheelWidget({super.key, required this.onResult, this.isSpinning = false});

  @override
  State<FortuneWheelWidget> createState() => _FortuneWheelWidgetState();
}

class _FortuneWheelWidgetState extends State<FortuneWheelWidget> {
  bool _canClose = false;
  int? _selectedMultiplier;
  late StreamController<int> _controller;
  late List<int> multipliers;

  @override
  void initState() {
    super.initState();
    multipliers = [
      ...List.filled(5, 10),
      ...List.filled(4, 25),
      ...List.filled(3, 50),
      ...List.filled(2, 75),
      100,
    ];
    multipliers.shuffle();
  _controller = StreamController<int>();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void spinWheel() {
    // Her spin'de segmentleri karıştır
  multipliers.shuffle();
  final selected = multipliers.first;
  final index = 0;
  _selectedMultiplier = selected;
  _controller.add(index);
  // Artık onResult animasyon bitince ve ekrana tıklanınca tetiklenecek
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _canClose ? () => widget.onResult(_selectedMultiplier ?? multipliers.first) : null,
      child: Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          height: MediaQuery.of(context).size.width * 0.85,
          child: FortuneWheel(
            selected: _controller.stream,
            items: [
              for (var m in multipliers)
                FortuneItem(
                  child: Text('x$m', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  style: FortuneItemStyle(
                    color: m == 10 ? Color(0xFF4CAF50)
                      : m == 25 ? Color(0xFF2196F3)
                      : m == 50 ? Color(0xFF9C27B0)
                      : m == 75 ? Color(0xFFFF9800)
                      : Color(0xFFFFD700),
                    borderColor: Colors.white,
                  ),
                ),
            ],
            indicators: const <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: Icon(Icons.arrow_drop_down, size: 60, color: Colors.amber),
              ),
            ],
            duration: const Duration(milliseconds: 3500),
            onAnimationEnd: () {
              setState(() {
                _canClose = true;
              });
            },
          ),
        ),
      ),
    );
  }
}
