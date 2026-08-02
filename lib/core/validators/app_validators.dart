/// Aturan validasi terpusat supaya rule sama di register, reset, dan edit password.
abstract final class AppValidators {
  static const int passwordMinLength = 8;

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Password wajib diisi';
    if (v.length < passwordMinLength) {
      return 'Password minimal $passwordMinLength karakter';
    }
    return null;
  }

  static String? passwordConfirm(String password, String konfirmasi) {
    if (password != konfirmasi) return 'Konfirmasi password tidak cocok';
    return null;
  }
}
