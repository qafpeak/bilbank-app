import 'package:bilbank_app/core/utils/validate_functions.dart';
import 'package:bilbank_app/presentation/components/common/app_text_field.dart';
import 'package:bilbank_app/presentation/components/common/primary_button.dart';
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_components/divider_with_text.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_components/forget_password_link.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_components/login_header.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_components/register_link.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_components/remember_me_check_box.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_components/social_login_row.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_screen_view_model.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_screen_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with WidgetsBindingObserver, LoginScreenMixin {
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final screenHeight = mq.size.height;
    final screenWidth = mq.size.width;
    final keyboardHeight = mq.viewInsets.bottom;
    return CustomGradientScaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: keyboardHeight > 0
                  ? const AlwaysScrollableScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: 16,
                    ),
                    child: Column(
                      children: [
                        const LoginHeader(),
                        SizedBox(height: screenHeight * 0.03),

                        Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              AppTextField(
                                controller: emailController,
                                label: 'E-posta',
                                hint: 'ornek@email.com',
                                prefixIcon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.compose([
                                  Validators.required('E-posta gerekli'),
                                  Validators.email(
                                    'Geçerli bir e-posta giriniz',
                                  ),
                                ]),
                              ),
                              const SizedBox(height: 14),
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
                                validator: Validators.compose([
                                  Validators.required('Şifre gerekli'),
                                  Validators.strongPassword(
                                    min: 6,
                                    requireUpper: true,
                                    requireLower: true,
                                    requireDigit: true,
                                    // requireSpecial: true, // isterse aç
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        Consumer<LoginScreenViewModel>(
                          builder: (_, vm, __) => Column(
                            children: [
                              RememberMeCheckbox(
                                value: vm.rememberMe,
                                onChanged: (value) async {
                                  if (value) {
                                    vm.rememberMe = true;
                                  } else {
                                    await vm
                                        .clearRememberMe(); // 🔥 LocalStorage'tan sil
                                    
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              PrimaryButton(
                                text: "Giriş Yap",
                                loading: vm.isLoading,
                                onPressed: submit,
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.015),

                        const ForgotPasswordLink(),

                        SizedBox(height: screenHeight * 0.025),

                        const DividerWithText(text: 'veya'),

                        SizedBox(height: screenHeight * 0.02),

                        SocialLoginsRow(onGoogle: () {}, onApple: () {}),

                        const Spacer(),
                        const RegisterLink(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
