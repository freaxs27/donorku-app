import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'reset_sukses_page.dart';

// LP-003).
class AturPasswordPage extends StatefulWidget {
  const AturPasswordPage({super.key});

  @override
  State<AturPasswordPage> createState() => _AturPasswordPageState();
}

class _AturPasswordPageState extends State<AturPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _aturUlang() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ResetSuksesPage()),
    );
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
              onPressed: _aturUlang,
              child: const Text('Atur Ulang Password'),
            ),
          ],
        ),
      ),
    );
  }
}