import 'package:bilbank_app/data/models/requests/login_register_request.dart';
import 'package:bilbank_app/presentation/navigation/app_page_keys.dart';
import 'package:bilbank_app/presentation/modules/auth_module/register_account/register_account_view.dart';
import 'package:bilbank_app/presentation/modules/auth_module/register_account/register_account_view_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

mixin RegisterAccountMixin on State<RegisterAccountView> {
  // Form & Controllers
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final TextEditingController _emailController = TextEditingController();
  TextEditingController get emailController => _emailController;

  final TextEditingController _usernameController = TextEditingController();
  TextEditingController get usernameController => _usernameController;

  final TextEditingController _nameController = TextEditingController();
  TextEditingController get nameController => _nameController;

  final TextEditingController _surnameController = TextEditingController();
  TextEditingController get surnameController => _surnameController;

  final TextEditingController _passwordController = TextEditingController();
  TextEditingController get passwordController => _passwordController;

  final TextEditingController _confirmController = TextEditingController();
  TextEditingController get confirmController => _confirmController;

  final TextEditingController _birthDateController = TextEditingController();
  TextEditingController get birthDateController => _birthDateController;

  bool _obscurePassword = true;
  bool get obscurePassword => _obscurePassword;
  set obscurePassword(bool value) => _obscurePassword = value;

  bool _obscureConfirm = true;
  bool get obscureConfirm => _obscureConfirm;
  set obscureConfirm(bool value) => _obscureConfirm = value;

  // ViewModel
  late final RegisterAccountViewModel _viewModel;
  RegisterAccountViewModel get viewModel => _viewModel;

  DateTime? _selectedDate;

  String? validateBirth(String? v) {
    if (v == null || v.isEmpty) return 'Doğum tarihi gerekli';
    if (_selectedDate == null) return 'Geçerli bir tarih seçiniz';
    final today = DateTime.now();
    final fifteenYearsAgo = DateTime(today.year - 15, today.month, today.day);
    final ok =
        _selectedDate!.isBefore(fifteenYearsAgo) ||
        _selectedDate!.isAtSameMomentAs(fifteenYearsAgo);
    if (!ok) return '15 yaşından büyük olmalısınız';
    return null;
  }

  Future<void> pickDate() async {
    final now = DateTime.now();
    final minDate = DateTime(now.year - 100);
    final maxDate = DateTime(now.year - 15, now.month, now.day);

    final picked = await showDatePicker(
      context: context,
      initialDate: maxDate,
      firstDate: minDate,
      lastDate: maxDate,
      locale: const Locale('tr', 'TR'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF4F46E5),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text =
            '${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _viewModel = RegisterAccountViewModel();
    _viewModel.addListener(_onViewModelChanged);
  }

  void _onViewModelChanged() {
    if (!mounted) return;
    setState(() {});

    // 🔒 Yükleme aşamasında veya daha sonuç yokken asla mesaj gösterme
    if (viewModel.isLoading || viewModel.registerResponse == null) return;

    final resp = viewModel.registerResponse!;
    // Mesajı tek seferde göster, ardından (istersen) response'u tüket.
    if (resp.isSuccess == true) {
      showScaffoldMessenger("Kayıt başarılı, giriş yapabilirsiniz.");
      context.go(AppPageKeys.login);
    } else {
      final msg = resp.errorMessage ?? "Kayıt başarısız";
      showScaffoldMessenger(msg);
    }

    // ✅ Aynı sonucu tekrar işlememek için response'u sıfırla (notify etmeden)
    viewModel.clearRegisterResponse();
  }

  Future<void> registerAccount() async {
    if (_formKey.currentState?.validate() != true) return;
    await _viewModel.registerAccount(
      LoginRegisterRequest(
        email: _emailController.text,
        username: _usernameController.text,
        firstName: _nameController.text,
        lastName: _surnameController.text,
        password: _passwordController.text,
        birthDate: _birthDateController.text,
      ),
     
    );
  }

  @override
  void dispose() {
    _viewModel.removeListener(_onViewModelChanged);
    _viewModel.dispose();

    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();

    super.dispose();
  }

  void showScaffoldMessenger(String message);
}
