// widgets/social_logins_row.dart
import 'package:flutter/material.dart';
import 'social_button.dart';

class SocialLoginsRow extends StatelessWidget {
  final VoidCallback onGoogle;
  final VoidCallback onApple;

  const SocialLoginsRow({
    super.key,
    required this.onGoogle,
    required this.onApple,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SocialButton(icon: Icons.g_mobiledata, label: 'Google', onPressed: onGoogle)),
        const SizedBox(width: 12),
        Expanded(child: SocialButton(icon: Icons.apple, label: 'Apple', onPressed: onApple)),
      ],
    );
  }
}
