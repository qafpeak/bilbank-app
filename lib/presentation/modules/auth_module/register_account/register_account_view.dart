import 'package:bilbank_app/presentation/components/common/app_text_field.dart';
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/components/pages/register/register_button.dart';
import 'package:bilbank_app/presentation/components/pages/register/register_login_link.dart';
import 'package:bilbank_app/presentation/modules/auth_module/register_account/register_account_mixin.dart';
import 'package:bilbank_app/presentation/modules/auth_module/register_account/register_account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterAccountView extends StatefulWidget {
  const RegisterAccountView({super.key});

  @override
  State<RegisterAccountView> createState() => _RegisterAccountViewState();
}

class _RegisterAccountViewState extends State<RegisterAccountView>
    with RegisterAccountMixin {
  String? _validateEmail(String? v) {
    if (v == null || v.isEmpty) return 'E-posta gerekli';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v))
      return 'Geçerli bir e-posta giriniz';
    return null;
  }

  String? _validatePassword(String? v) {
    if (v == null || v.isEmpty) return 'Şifre gerekli';
    if (v.length < 6) return 'Şifre en az 6 karakter olmalı';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(v)) {
      return 'En az 1 büyük harf, 1 küçük harf ve 1 rakam içermeli';
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if (v == null || v.isEmpty) return 'Şifre tekrarı gerekli';
    if (v != passwordController.text) return 'Şifreler eşleşmiyor';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // Bu sayfada kullanılan VM’yi provide ediyoruz
    return ChangeNotifierProvider.value(
      value: viewModel,
      child: CustomGradientScaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Hesap Oluştur',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'E-posta ve şifreni belirle',
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.2)),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        AppTextField(
                          controller: usernameController,
                          label: 'Kullanıcı Adı',
                          hint: 'username',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: AppTextField(
                                controller: nameController,
                                label: 'Ad',
                                hint: 'Adınızı giriniz',
                                prefixIcon: Icons.badge_outlined,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: AppTextField(
                                controller: surnameController,
                                label: 'Soyad',
                                hint: 'Soyadınızı giriniz',
                                prefixIcon: Icons.badge_outlined,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                        controller: birthDateController,
                        label: 'Doğum Tarihi',
                        hint: 'GG/AA/YYYY',
                        prefixIcon: Icons.calendar_today_outlined,
                        readOnly: true,
                        onTap: pickDate,
                        validator: validateBirth,
                      ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: emailController,
                          label: 'E-posta',
                          hint: 'ornek@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: _validateEmail,
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
                              obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            onPressed: () => setState(
                              () => obscurePassword = !obscurePassword,
                            ),
                          ),
                          validator: _validatePassword,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          controller: confirmController,
                          label: 'Şifre Tekrarı',
                          hint: 'Şifrenizi tekrar giriniz',
                          prefixIcon: Icons.lock_outline,
                          obscureText: obscureConfirm,
                          suffixIcon: IconButton(
                            icon: Icon(
                              obscureConfirm
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            onPressed: () => setState(
                              () => obscureConfirm = !obscureConfirm,
                            ),
                          ),
                          validator: _validateConfirm,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Consumer<RegisterAccountViewModel>(
                  builder: (_, vm, __) => RegisterButton(
                    isLoading: vm.isLoading,
                    onPressed: registerAccount,
                  ),
                ),
                const SizedBox(height: 24),
                const RegisterLoginLink(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void showScaffoldMessenger(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
