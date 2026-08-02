import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_theme.dart';
import '../../../core/locale/app_strings.dart';
import '../../../model/data_register.dart';
import '../../../services/auth/auth_service.dart';
import '../../../services/core/api_exception.dart';
import 'register_sukses_page.dart';
import '../../../widgets/theme_sync.dart';

// (R-003).
class FotoDiriPage extends StatefulWidget {
  final DataRegister data;

  const FotoDiriPage({super.key, required this.data});

  @override
  State<FotoDiriPage> createState() => _FotoDiriPageState();
}

class _FotoDiriPageState extends State<FotoDiriPage> {
  File? _fotoDiri;
  bool _sedangMemproses = false; 
  bool _sedangKirim = false; 
  final AuthService _authService = AuthService();

  Future<void> _ambilFotoDiri() async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
      preferredCameraDevice: CameraDevice.front,
    );
    if (foto == null) return; 

    setState(() => _sedangMemproses = true);
    await Future.delayed(const Duration(milliseconds: 200));

    setState(() {
      _fotoDiri = File(foto.path);
      _sedangMemproses = false;
    });
  }

  Future<void> _buatAkun() async {
    final data = widget.data;

    if (data.nik == null ||
        data.tanggalLahir == null ||
        data.alamat == null ||
        data.golonganDarah == null ||
        data.profesi == null ||
        data.jenisKelamin == null) {
      _tampilkanPesan(AppStrings.of(context).ktpDataIncomplete);
      return;
    }

    setState(() => _sedangKirim = true);

    try {
      await _authService.register(
        namaLengkap: data.namaLengkap,
        email: data.email,
        noHp: data.noHp,
        kota: data.kota,
        password: data.password,
        passwordConfirm: data.passwordConfirm,
        nik: data.nik!,
        tanggalLahir: data.tanggalLahir!,
        alamat: data.alamat!,
        golonganDarah: data.golonganDarah!,
        profesi: data.profesi!,
        jenisKelamin: data.jenisKelamin!,
        fotoDiri: _fotoDiri,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        AppPageRoute(builder: (context) => const RegisterSuksesPage()),
        (route) => false,
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
        leading: BackButton(color: AppColors.of(context).textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(s.createAccountTitle, style: AppTextStyles.heading(context)),
            ),
            const SizedBox(height: 20),

            Text(s.selfieTitle, style: AppTextStyles.subheading(context)),
            const SizedBox(height: 12),

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
              onPressed: (_fotoDiri != null && !_sedangKirim) ? _buatAkun : null,
              child: _sedangKirim
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(s.createAccountButton),
            ),
            const SizedBox(height: 16),

            Center(
              child: Text.rich(
                TextSpan(
                  style: AppTextStyles.body(context).copyWith(color: AppColors.of(context).textSecondary),
                  children: [
                    TextSpan(text: s.haveAccountPrompt),
                    TextSpan(
                      text: s.loginHereLink,
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
