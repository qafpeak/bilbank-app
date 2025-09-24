// widgets/forgot_password_link.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go('/forgot-password'),
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 4)),
      child: Text(
        'Şifremi Unuttum',
        style: TextStyle(
          color: Colors.white.withOpacity(0.8),
          fontSize: 13,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
