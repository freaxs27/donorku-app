import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'verifikasi_email_page.dart';

// (LP-001).
class LupaPasswordPage extends StatefulWidget {
  const LupaPasswordPage({super.key});

  @override
  State<LupaPasswordPage> createState() => _LupaPasswordPageState();
}

class _LupaPasswordPageState extends State<LupaPasswordPage> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _lanjutkan() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VerifikasiEmailPage(email: _emailController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar transparan cuma untuk tombol back, tanpa judul & tanpa shadow,
      // supaya persis seperti desain (back arrow polos di pojok kiri atas).
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Lupa Password', style: AppTextStyles.heading),
            const SizedBox(height: 4),
            const Text(
              'Masukan emailmu untuk mereset password',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 24),

            const Text('Email', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Masukan email'),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _lanjutkan,
              child: const Text('Selanjutnya'),
            ),
          ],
        ),
      ),
    );
  }
}