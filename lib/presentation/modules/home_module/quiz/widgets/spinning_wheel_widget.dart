import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'dart:async';


class SpinningWheelWidget extends StatefulWidget {
  final Function(int) onResult;
  final bool isSpinning;
  const SpinningWheelWidget({super.key, required this.onResult, this.isSpinning = false});

  @override
  State<SpinningWheelWidget> createState() => _SpinningWheelWidgetState();
}

class _SpinningWheelWidgetState extends State<SpinningWheelWidget> {
  late StreamController<int> _controller;
  final List<int> multipliers = [10, 25, 50, 75, 100];

  @override
  void initState() {
    super.initState();
    _controller = StreamController<int>();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void spinWheel() {
    final selected = (multipliers..shuffle()).first;
    final index = multipliers.indexOf(selected);
    _controller.add(index);
    Future.delayed(const Duration(seconds: 3), () {
      Future.microtask(() => widget.onResult(multipliers[index]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: FortuneWheel(
            selected: _controller.stream,
            items: [
              for (var m in multipliers)
                FortuneItem(
                  child: Text('x$m', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  style: FortuneItemStyle(
                    color: Colors.orangeAccent,
                    borderColor: Colors.white,
                  ),
                ),
            ],
            indicators: const <FortuneIndicator>[
              FortuneIndicator(
                alignment: Alignment.topCenter,
                child: Icon(Icons.arrow_drop_down, size: 40, color: Colors.amber),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: widget.isSpinning ? null : spinWheel,
          icon: const Icon(Icons.casino, color: Colors.amber),
          label: const Text('Çarkı Çevir ve Multiplier Kazan!'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
