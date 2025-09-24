
import 'dart:ui';

import 'package:flutter/material.dart';

class CustomGradientScaffold extends StatelessWidget {
  const CustomGradientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.bottomNavigationBar,
    this.gradientColors,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? bottomNavigationBar;
  final List<Color>? gradientColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       extendBodyBehindAppBar: true,        // 👈 önemli
      backgroundColor: Colors.transparent, // 👈 arka planı şeffaf tu
      appBar: appBar,
      extendBody: true, // NavBar altına taşan efektler için
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors ??
                const [
                  Color(0xFF4F46E5), // morumsu mavi
                  Color(0xFF3B82F6), // parlak mavi
                  Color(0xFF06B6D4), // cam göbeği
                ],
          ),
        ),
        child: SafeArea(child: body),
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

