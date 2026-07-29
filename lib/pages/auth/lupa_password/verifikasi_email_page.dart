import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import 'atur_password_page.dart';

// (LP-002)
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

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _jumlahKotak - 1) {
      // Pindah otomatis ke kotak berikutnya saat user selesai mengetik 1 digit.
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      // Kalau dihapus (backspace), balik fokus ke kotak sebelumnya.
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _verifikasi() {
    final kode = _controllers.map((c) => c.text).join();
    debugPrint('Kode OTP dimasukkan: $kode');

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AturPasswordPage()),
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
            const Text('Verifikasi Email', style: AppTextStyles.heading),
            const SizedBox(height: 4),
            Text(
              'Kami telah mengirim email kepada kakamr@gmail.com \nMasukan kode yang ada di email',
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
              onPressed: _verifikasi,
              child: const Text('Verifikasi'),
            ),
            const SizedBox(height: 16),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: 'Belum mendapatkan kode? '),
                    TextSpan(
                      text: 'Kirim ulang',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
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