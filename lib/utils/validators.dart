/// Utility class untuk validasi dan sanitasi input form.
class Validators {
  static final RegExp _emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  static final RegExp _phoneRegex = RegExp(r'^[0-9]{10,13}$');
  static final RegExp _urlRegex = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );
  static final RegExp _passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*\d)(?=.*[!@#$%^&*(),.?":{}|<>_\-\[\]\\\/]).{8,}$',
  );

  /// a) Memeriksa apakah format email valid (mengembalikan boolean).
  static bool isValidEmail(String? email) {
    if (email == null || email.trim().isEmpty) return false;
    return _emailRegex.hasMatch(email.trim());
  }

  /// b) Membersihkan input dari potensi injeksi skrip/HTML berbahaya.
  static String sanitize(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('/', '&#x2F;');
  }

  /// c) Validasi teks dengan batasan panjang minimal dan maksimal.
  static String? validateText(
    String? value, {
    int minLength = 3,
    int maxLength = 255,
  }) {
    if (value == null || value.trim().isEmpty) {
      return 'Teks tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (trimmed.length < minLength) {
      return 'Panjang minimal $minLength karakter';
    }
    if (trimmed.length > maxLength) {
      return 'Panjang maksimal $maxLength karakter';
    }
    return null;
  }

  /// Validasi nama wajib diisi dan minimal 3 karakter.
  static String? validateName(String? value) {
    return validateText(value, minLength: 3, maxLength: 50);
  }

  /// Validasi format email form.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    if (!isValidEmail(value)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Validasi nomor telepon (hanya angka, 10-13 digit).
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (!_phoneRegex.hasMatch(trimmed)) {
      return 'Nomor telepon harus berupa angka antara 10 sampai 13 digit';
    }
    return null;
  }

  /// Validasi URL (harus dimulai dengan http:// atau https://).
  static String? validateUrl(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'URL tidak boleh kosong';
    }
    final trimmed = value.trim();
    if (!trimmed.startsWith('http://') && !trimmed.startsWith('https://')) {
      return 'URL harus diawali dengan http:// atau https://';
    }
    if (!_urlRegex.hasMatch(trimmed)) {
      return 'Format URL tidak valid';
    }
    return null;
  }

  /// Validasi password ketat.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    if (!_passwordRegex.hasMatch(value)) {
      return 'Password harus mengandung minimal satu huruf kapital, satu angka, dan satu simbol khusus';
    }
    return null;
  }
}