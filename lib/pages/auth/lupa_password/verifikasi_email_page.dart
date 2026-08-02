// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../theme/app_theme.dart';
import '../../../core/locale/app_strings.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/core/api_exception.dart';
import 'atur_password_page.dart';

// (LP-002).
class VerifikasiEmailPage extends StatefulWidget {
  final String email;

  const VerifikasiEmailPage({super.key, required this.email});

  @override
  State<VerifikasiEmailPage> createState() => _VerifikasiEmailPageState();
}

class _VerifikasiEmailPageState extends State<VerifikasiEmailPage> {
  static const int _jumlahKotak = 6;

  final List<TextEditingController> _controllers =
      List.generate(_jumlahKotak, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_jumlahKotak, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  final AuthService _authService = AuthService();
  bool _sedangVerifikasi = false;
  bool _sedangKirimUlang = false;

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _jumlahKotak - 1) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifikasi() async {
    final kode = _controllers.map((c) => c.text).join();
    if (kode.length != _jumlahKotak) {
      _tampilkanPesan(AppStrings.of(context).otpIncomplete);
      return;
    }

    setState(() => _sedangVerifikasi = true);
    try {
      await _authService.verifikasiOtp(email: widget.email, otp: kode);
      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => AturPasswordPage(email: widget.email, otp: kode),
        ),
      );
    } on ApiException catch (e) {
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan(AppStrings.of(context).unexpectedError);
    } finally {
      if (mounted) setState(() => _sedangVerifikasi = false);
    }
  }

  Future<void> _kirimUlang() async {
    setState(() => _sedangKirimUlang = true);
    try {
      final pesan = await _authService.kirimOtpLupaPassword(email: widget.email);
      _tampilkanPesan(pesan);
    } on ApiException catch (e) {
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan(AppStrings.of(context).resendCodeFailed);
    } finally {
      if (mounted) setState(() => _sedangKirimUlang = false);
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
            Text(s.verifyEmailTitle, style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(
              s.verifyEmailSubtitle(widget.email),
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(_jumlahKotak, (index) {
                return SizedBox(
                  width: 45,
                  height: 52,
                  child: TextField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    style: AppTextStyles.subheading,
                    decoration: const InputDecoration(
                      counterText: '', 
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value) => _onChanged(index, value),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _sedangVerifikasi ? null : _verifikasi,
              child: _sedangVerifikasi
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(s.verifyButton),
            ),
            const SizedBox(height: 16),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: s.noCodePrompt),
                    TextSpan(
                      text: _sedangKirimUlang ? s.sendingLink : s.resendLink,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = _sedangKirimUlang ? null : _kirimUlang,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
