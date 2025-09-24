import 'package:flutter/material.dart';

class DecorativeDivider extends StatelessWidget {
  const DecorativeDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.keyboard_arrow_left_outlined,
          color: Colors.white,
          size: 30,
        ),
        Expanded(child: Divider(thickness: 2)),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: ClipPath(
            clipper: DiamondClipper(),
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.white),
              child: SizedBox(width: 25, height: 25),
            ),
          ),
        ),
        Expanded(child: Divider(thickness: 2)),
        Icon(Icons.keyboard_arrow_right_outlined,
          color: Colors.white,
          size: 30,
        ),
      ],
    );
  }
}

class DiamondClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width / 2, 0); // üst orta
    path.lineTo(size.width, size.height / 2); // sağ orta
    path.lineTo(size.width / 2, size.height); // alt orta
    path.lineTo(0, size.height / 2); // sol orta
    path.close(); // şekli kapat

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false; // şekil değişmeyecekse false
  }
}
