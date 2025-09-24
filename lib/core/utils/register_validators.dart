// lib/features/auth/register/validators/register_validators.dart
class RegisterValidators {
  static String? username(String? value) {
    if (value == null || value.isEmpty) return 'Kullanıcı adı gerekli';
    if (value.length < 3) return 'Kullanıcı adı en az 3 karakter olmalı';
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Sadece harf, rakam ve _ kullanabilirsiniz';
    }
    return null;
  }

  static String? name(String? value) {
    if (value == null || value.isEmpty) return 'Ad gerekli';
    if (value.length < 2) return 'En az 2 karakter';
    return null;
  }

  static String? surname(String? value) {
    if (value == null || value.isEmpty) return 'Soyad gerekli';
    if (value.length < 2) return 'En az 2 karakter';
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.isEmpty) return 'E-posta gerekli';
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Geçerli bir e-posta giriniz';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Şifre gerekli';
    if (value.length < 6) return 'Şifre en az 6 karakter olmalı';
    if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)').hasMatch(value)) {
      return 'En az 1 büyük harf, 1 küçük harf ve 1 rakam içermeli';
    }
    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) return 'Şifre tekrarı gerekli';
    if (value != password) return 'Şifreler eşleşmiyor';
    return null;
  }
}
