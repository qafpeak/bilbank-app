import 'package:flutter/material.dart';

class FooterInfo extends StatelessWidget {
  final String emergencyText;
  final String email;
  final String phone;

  const FooterInfo({
    Key? key,
    required this.emergencyText,
    required this.email,
    required this.phone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Text.rich(
        TextSpan(
          text: emergencyText,
          style: TextStyle(color: Colors.grey[600], fontSize: 13),
          children: [
            TextSpan(
              text: email,
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            TextSpan(text: ' veya '),
            TextSpan(
              text: phone,
              style: TextStyle(
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
