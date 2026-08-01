import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/core/api_exception.dart';
import 'reset_sukses_page.dart';

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

    if (password.isEmpty) {
      _tampilkanPesan('Password wajib diisi');
      return;
    }
    if (password.length < 6) {
      _tampilkanPesan('Password minimal 6 karakter');
      return;
    }
    if (password != konfirmasi) {
      _tampilkanPesan('Konfirmasi password tidak sama');
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
        MaterialPageRoute(builder: (context) => const ResetSuksesPage()),
      );
    } on ApiException catch (e) {
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan('Terjadi kesalahan tak terduga, coba lagi');
    } finally {
      if (mounted) setState(() => _sedangProses = false);
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Atur Password Baru', style: AppTextStyles.heading),
            const SizedBox(height: 4),
            const Text(
              'Masukan password yang baru',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),

            const Text('Password', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Masukan password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            const Text('Konfirmasi Password', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _konfirmasiController,
              obscureText: _obscureKonfirmasi,
              decoration: InputDecoration(
                hintText: 'Masukan kembali password',
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureKonfirmasi
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
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
                  : const Text('Atur Ulang Password'),
            ),
          ],
        ),
      ),
    );
  }
}