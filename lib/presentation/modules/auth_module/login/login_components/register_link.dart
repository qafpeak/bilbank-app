// widgets/register_link.dart
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterLink extends StatelessWidget {
  const RegisterLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Hesabınız yok mu? ', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13)),
        TextButton(
          onPressed: () => context.push(AppPageKeys.registerAccuntPath),
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero, minimumSize: const Size(0, 0), tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: const Text(
            'Kayıt Ol',
            style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
          ),
        ),
      ],
    );
  }
}
