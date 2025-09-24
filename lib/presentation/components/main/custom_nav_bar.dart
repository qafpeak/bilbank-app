import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({
    super.key,
    required this.onTap,
    required this.currentIndex,
  });

  /// Sekmeye tıklanınca çalışacak fonksiyon
  final Function(int index)? onTap;

  /// Hangi sekmenin aktif olduğunu belirtir
  final int currentIndex;

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return SalomonBottomBar(
      // Şu an aktif olan sekme index'i
      currentIndex: widget.currentIndex,

      // Tıklama durumunda callback fonksiyon çağrılır
      onTap: (index) => widget.onTap?.call(index),

      items: [
        /// 1. Sekme: Ana Sayfa
        SalomonBottomBarItem(
          icon: Icon(Icons.home, size: 40),
          title: const Text(
            "Ana Sayfa",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          selectedColor: Colors.white,
          unselectedColor: Colors.white70,
        ),

        /// 2. Sekme: Profil
        SalomonBottomBarItem(
          icon: const Icon(Icons.person, size: 40),
          title: const Text(
            "Profil",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          selectedColor: Colors.white,
          unselectedColor: Colors.white70,
        ),

        /// 3. Sekme: Çark Marketi (ikon görsel olarak verilmiş)
        SalomonBottomBarItem(
          icon: SizedBox(
              width: 40,
              height: 40,
              child: SvgPicture.asset("assets/svg/ic_fortune_store.svg",color: Colors.white,)),
          title: const Text(
            "Çark",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          selectedColor: Colors.white,
          unselectedColor: Colors.white70,
        ),

        /// 4. Sekme: Elmas Marketi (ikon görsel olarak verilmiş)
        SalomonBottomBarItem(
          icon: const Icon(Icons.diamond, size: 40),
          title: const Text(
            "Elmas",
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'Poppins',
              color: Colors.white,
            ),
          ),
          selectedColor: Colors.white,
          unselectedColor: Colors.white70,
        ),
      ],
    );
  }
}
