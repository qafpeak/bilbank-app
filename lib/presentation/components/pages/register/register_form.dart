import 'package:bilbank_app/core/utils/register_validators.dart';
import 'package:bilbank_app/presentation/components/common/app_text_field.dart';
import 'package:flutter/material.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    required this.formKey,
    required this.usernameController,
    required this.nameController,
    required this.surnameController,
    required this.birthDateController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.obscurePassword,
    required this.obscureConfirmPassword,
    required this.onTogglePassword,
    required this.onToggleConfirmPassword,
    required this.onPickDate,
    required this.validateBirthDate,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController usernameController;
  final TextEditingController nameController;
  final TextEditingController surnameController;
  final TextEditingController birthDateController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  final bool obscurePassword;
  final bool obscureConfirmPassword;

  final VoidCallback onTogglePassword;
  final VoidCallback onToggleConfirmPassword;
  final VoidCallback onPickDate;

  final String? Function(String?) validateBirthDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            AppTextField(
              controller: usernameController,
              label: 'Kullanıcı Adı',
              hint: 'Kullanıcı adınızı giriniz',
              prefixIcon: Icons.person_outline,
              validator: RegisterValidators.username,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: nameController,
                    label: 'Ad',
                    hint: 'Adınız',
                    prefixIcon: Icons.badge_outlined,
                    validator: RegisterValidators.name,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppTextField(
                    controller: surnameController,
                    label: 'Soyad',
                    hint: 'Soyadınız',
                    prefixIcon: Icons.badge_outlined,
                    validator: RegisterValidators.surname,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppTextField
            (
              controller: birthDateController,
              label: 'Doğum Tarihi',
              hint: 'GG/AA/YYYY',
              prefixIcon: Icons.calendar_today_outlined,
              readOnly: true,
              onTap: onPickDate,
              validator: validateBirthDate,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: emailController,
              label: 'E-posta',
              hint: 'ornek@email.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: RegisterValidators.email,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: passwordController,
              label: 'Şifre',
              hint: 'Şifrenizi giriniz',
              prefixIcon: Icons.lock_outline,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: onTogglePassword,
              ),
              validator: RegisterValidators.password,
            ),
            const SizedBox(height: 16),
            AppTextField(
              controller: confirmPasswordController,
              label: 'Şifre Tekrarı',
              hint: 'Şifrenizi tekrar giriniz',
              prefixIcon: Icons.lock_outline,
              obscureText: obscureConfirmPassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscureConfirmPassword
                      ? Icons.visibility_off
                      : Icons.visibility,
                  color: Colors.white.withOpacity(0.7),
                ),
                onPressed: onToggleConfirmPassword,
              ),
              validator: (v) =>
                  RegisterValidators.confirmPassword(v, passwordController.text),
            ),
          ],
        ),
      ),
    );
  }
}
