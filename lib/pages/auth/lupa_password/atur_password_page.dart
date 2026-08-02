import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../core/locale/app_strings.dart';
import '../../../core/validators/app_validators.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/core/api_exception.dart';
import 'reset_sukses_page.dart';
import '../../../widgets/theme_sync.dart';

// (LP-003).
class AturPasswordPage extends StatefulWidget {
  final String email;
  final String otp;

  const AturPasswordPage({super.key, required this.email, required this.otp});

  @override
  State<AturPasswordPage> createState() => _AturPasswordPageState();
}

class _AturPasswordPageState extends State<AturPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;
  bool _sedangProses = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  Future<void> _aturUlang() async {
    final password = _passwordController.text;
    final konfirmasi = _konfirmasiController.text;

    final errPass = AppValidators.password(password);
    if (errPass != null) {
      _tampilkanPesan(errPass);
      return;
    }
    final errKonfirm = AppValidators.passwordConfirm(password, konfirmasi);
    if (errKonfirm != null) {
      _tampilkanPesan(errKonfirm);
      return;
    }

    setState(() => _sedangProses = true);
    try {
      await _authService.resetPassword(
        email: widget.email,
        otp: widget.otp,
        passwordBaru: password,
      );
      if (!mounted) return;
      Navigator.of(context).push(
        AppPageRoute(builder: (context) => const ResetSuksesPage()),
      );
    } on ApiException catch (e) {
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan(AppStrings.of(context).unexpectedError);
    } finally {
      if (mounted) setState(() => _sedangProses = false);
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: AppColors.of(context).textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.setNewPasswordTitle, style: AppTextStyles.heading(context)),
            const SizedBox(height: 4),
            Text(
              s.setNewPasswordSubtitle,
              style: AppTextStyles.caption(context),
            ),
            const SizedBox(height: 24),

            Text(s.passwordLabel, style: AppTextStyles.body(context)),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: s.passwordHint,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.of(context).textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            Text(s.confirmPasswordLabel, style: AppTextStyles.body(context)),
            const SizedBox(height: 8),
            TextField(
              controller: _konfirmasiController,
              obscureText: _obscureKonfirmasi,
              decoration: InputDecoration(
                hintText: s.confirmPasswordHint,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureKonfirmasi
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.of(context).textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscureKonfirmasi = !_obscureKonfirmasi);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _sedangProses ? null : _aturUlang,
              child: _sedangProses
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(s.resetPasswordButton),
            ),
          ],
        ),
      ),
    );
  }
}
