import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_screen.dart';
import 'package:bilbank_app/presentation/modules/auth_module/login/login_screen_view_model.dart';
import 'package:bilbank_app/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

mixin LoginScreenMixin on State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool v) => setState(() => _obscurePassword = v);

  late LoginScreenViewModel vm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      vm = context.read<LoginScreenViewModel>();
      await vm.loadRememberedValues();

      // 🟢 Controller'lara yaz!
      emailController.text = vm.email;
      passwordController.text = vm.password;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final vm = context.read<LoginScreenViewModel>();
    final userProvider = context.read<UserProvider>();

    if (!formKey.currentState!.validate()) return;

    final ok = await vm.login(
      emailController.text.trim(),
      passwordController.text,
      userProvider: userProvider,
    );

    if (!mounted) return;

    if (ok) {
      context.go(AppPageKeys.home);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Giriş başarılı')),
      );
    } else {
      final msg = vm.apiResponse?.errorMessage ?? 'Giriş başarısız';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }
}
