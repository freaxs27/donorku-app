import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import 'register_sukses_page.dart';

// (R-003).
class FotoDiriPage extends StatefulWidget {
  const FotoDiriPage({super.key});

  @override
  State<FotoDiriPage> createState() => _FotoDiriPageState();
}

class _FotoDiriPageState extends State<FotoDiriPage> {
  File? _fotoDiri;
  bool _sedangMemproses = false;

  Future<void> _ambilFotoDiri() async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      // Kamera depan, karena ini foto selfie sambil pegang KTP.
      preferredCameraDevice: CameraDevice.front,
    );
    if (foto == null) return; // user batal ambil foto

    setState(() => _sedangMemproses = true);
    // Delay kecil biar transisi loading terlihat natural (opsional,
    // di sini juga bisa dipakai kalau nanti ada proses tambahan
    // seperti kompresi/upload foto).
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      _fotoDiri = File(foto.path);
      _sedangMemproses = false;
    });
  }

  void _buatAkun() {    // 
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const RegisterSuksesPage()),
      (route) => false,
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
            const Center(
              child: Text('Buat Akunmu', style: AppTextStyles.heading),
            ),
            const SizedBox(height: 20),

            const Text('Foto Diri', style: AppTextStyles.subheading),
            const SizedBox(height: 12),

            // Kotak kamera / preview foto diri
            GestureDetector(
              onTap: _sedangMemproses ? null : _ambilFotoDiri,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: _sedangMemproses
                    ? const Center(child: CircularProgressIndicator())
                    : _fotoDiri != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimens.radiusM),
                            child: Image.file(_fotoDiri!, fit: BoxFit.cover, width: double.infinity),
                          )
                        : const Center(
                            child: Icon(Icons.camera_alt_outlined, size: 48, color: Colors.black),
                          ),
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _fotoDiri != null ? _buatAkun : null,
              child: const Text('Buat Akun'),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: 'Sudah punya akun? '),
                    TextSpan(
                      text: 'login disini',
                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}