typedef Validator = String? Function(String? value);

class Validators {
  Validators._();

  /// Birden fazla validator'ı sırayla çalıştırır; ilk hata mesajını döner.
  static Validator compose(List<Validator> validators) {
    return (value) {
      for (final v in validators) {
        final res = v(value);
        if (res != null) return res;
      }
      return null;
    };
  }

  /// Boş olmamalı.
  static Validator required([String message = 'Bu alan zorunludur']) {
    return (value) {
      if (value == null || value.trim().isEmpty) return message;
      return null;
    };
  }

  /// E-posta formatı.
  static Validator email([String message = 'Geçerli bir e-posta giriniz']) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    return (value) {
      if (value == null || value.isEmpty) return null; // required ayrı
      if (!regex.hasMatch(value.trim())) return message;
      return null;
    };
  }

  /// Minimum uzunluk.
  static Validator minLength(int min, [String? message]) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min) {
        return message ?? 'En az $min karakter olmalı';
      }
      return null;
    };
  }

  /// Regex ile kontrol.
  static Validator pattern(RegExp regex, String message) {
    return (value) {
      if (value == null || value.isEmpty) return null;
      if (!regex.hasMatch(value)) return message;
      return null;
    };
  }

  /// Başka bir alanın değerine eşitlik kontrolü (ör. şifre tekrarı).
  static Validator match(
    String Function() otherValueGetter, [
    String message = 'Değerler eşleşmiyor',
  ]) {
    return (value) {
      if (value == null) return null;
      if (value != otherValueGetter()) return message;
      return null;
    };
  }

  /// Güçlü şifre kontrolü (isteğe bağlı kurallar).
  static Validator strongPassword({
    int min = 6,
    bool requireUpper = true,
    bool requireLower = true,
    bool requireDigit = true,
    bool requireSpecial = false,
    String? message,
  }) {
    final upper = RegExp(r'[A-Z]');
    final lower = RegExp(r'[a-z]');
    final digit = RegExp(r'\d');

    final special = RegExp(r'''[!@#\$%^&*(),.?":{}|<>_\-\\/\[\];'`~+=]''');

    return (value) {
      if (value == null || value.isEmpty) return null;
      if (value.length < min) {
        return 'Şifre en az $min karakter olmalı';
      }
      if (requireUpper && !upper.hasMatch(value)) {
        return message ?? 'En az 1 büyük harf içermeli';
      }
      if (requireLower && !lower.hasMatch(value)) {
        return message ?? 'En az 1 küçük harf içermeli';
      }
      if (requireDigit && !digit.hasMatch(value)) {
        return message ?? 'En az 1 rakam içermeli';
      }
      if (requireSpecial && !special.hasMatch(value)) {
        return message ?? 'En az 1 özel karakter içermeli';
      }
      return null;
    };
  }
}
