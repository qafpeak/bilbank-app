import 'package:bilbank_app/presentation/components/common/app_text_field.dart';
import 'package:bilbank_app/presentation/components/common/gradient_button.dart';
import 'package:bilbank_app/presentation/components/main/custom_gradient_scaffold.dart';
import 'package:bilbank_app/presentation/modules/profile_module/edit_profile/edit_profile_view_mixin.dart';
import 'package:flutter/material.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key, this.onSubmit});

  final Future<void> Function({
    required String firstName,
    required String lastName,
  })?
  onSubmit;

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView>
    with EditProfileViewMixin {
  @override
  Widget build(BuildContext context) {
    return CustomGradientScaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profil Düzenle',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsetsGeometry.all(16),
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
                ),
                const SizedBox(height: 16),
                AppTextField(
                  controller: emailController,
                  label: 'E-posta',
                  hint: 'ornek@email.com',
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24),
                GradientButton(text: "Kaydet", icon: Icons.check, onTap: () {}),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
