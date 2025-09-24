import 'package:bilbank_app/presentation/modules/profile_module/edit_profile/edit_profile_view.dart';
import 'package:flutter/material.dart';

mixin EditProfileViewMixin on State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  get formKey => _formKey;

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
}
