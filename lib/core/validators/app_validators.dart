import '../locale/app_strings.dart';

/// Aturan validasi terpusat supaya rule sama di register, reset, dan edit password.
abstract final class AppValidators {
  static const int passwordMinLength = 8;

  static String? password(String? value) {
    final s = AppStrings.current;
    final v = value ?? '';
    if (v.isEmpty) return s.passwordRequired;
    if (v.length < passwordMinLength) {
      return s.passwordMinLength(passwordMinLength);
    }
    return null;
  }

  static String? passwordConfirm(String password, String konfirmasi) {
    if (password != konfirmasi) return AppStrings.current.passwordConfirmMismatch;
    return null;
  }
}
