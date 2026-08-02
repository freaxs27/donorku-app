import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../core/locale/app_strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/core/api_exception.dart';
import 'verifikasi_email_page.dart';

// (LP-001).
class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _sedangKirim = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _lanjutkan() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _tampilkanPesan(AppStrings.of(context).enterValidEmail);
      return;
    }

    setState(() => _sedangKirim = true);
    try {
      await _authService.kirimOtpLupaPassword(email: email);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VerifikasiEmailPage(email: email),
        ),
      );
    } on ApiException catch (e) {
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan(AppStrings.of(context).unexpectedError);
    } finally {
      if (mounted) setState(() => _sedangKirim = false);
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
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s.forgotPasswordTitle, style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(
              s.forgotPasswordSubtitle,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),

            Text(s.emailLabel, style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: s.emailHint),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _sedangKirim ? null : _lanjutkan,
              child: _sedangKirim
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(s.nextButton),
            ),
          ],
        ),
      ),
    );
  }
}
