import 'package:flutter/material.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../services/profil/profil_service.dart';
import '../../services/core/api_exception.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _passSkrCtrl    = TextEditingController();
  final _passBrCtrl     = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();

  bool _lihatSkr    = false;
  bool _lihatBr     = false;
  bool _lihatKonfir = false;
  bool _sedangSimpan = false;

  final ProfilService _service = ProfilService();

  @override
  void dispose() {
    _passSkrCtrl.dispose();
    _passBrCtrl.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _tampilkanPopupPasswordSalah() async {
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 72, height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFFFFD8D8),
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: const Icon(Icons.close,
                            size: 36, color: AppColors.primary),
                      ),
                      const SizedBox(height: 16),
                      const Text('Password Salah',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      const Text(
                        'Anda salah memasukan password lama atau konfirmasi password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text('Coba Lagi',
                              style:
                                  TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close,
                        size: 20, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _simpan() async {
    final passSkr  = _passSkrCtrl.text.trim();
    final passBr   = _passBrCtrl.text.trim();
    final konfirm  = _konfirmasiCtrl.text.trim();

    if (passSkr.isEmpty || passBr.isEmpty || konfirm.isEmpty) {
      _tampilkanPesan(AppStrings.of(context).allFieldsRequired);
      return;
    }
    if (passBr.length < 8) {
      _tampilkanPesan('Password baru minimal 8 karakter');
      return;
    }
    if (passBr != konfirm) {
      await _tampilkanPopupPasswordSalah();
      return;
    }

    // Popup konfirmasi (Frame 11)
    final konfirmasi = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/icon-tanya.png', width: 72, height: 72),
              const SizedBox(height: 16),
              const Text('Konfirmasi Ubah',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text('Apakah anda yakin ingin mengubah password saat ini?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Ubah',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (konfirmasi != true || !mounted) return;

    setState(() => _sedangSimpan = true);
    try {
      await _service.gantiPassword(
        passwordSekarang: passSkr,
        passwordBaru: passBr,
        konfirmasiPasswordBaru: konfirm,
      );

      if (!mounted) return;
      _tampilkanPesan(AppStrings.of(context).passwordChanged);
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (!mounted) return;
      final isPasswordSalah = e.statusCode == 400 &&
          (e.message.toLowerCase().contains('password') ||
           e.message.toLowerCase().contains('sesuai'));
      if (isPasswordSalah) {
        await _tampilkanPopupPasswordSalah();
      } else {
        _tampilkanPesan(e.message);
      }
    } catch (_) {
      if (mounted) _tampilkanPesan(AppStrings.of(context).changePasswordFailed);
    } finally {
      if (mounted) setState(() => _sedangSimpan = false);
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back,
                        size: 28, color: AppColors.textPrimary),
                  ),
                  Expanded(
                    child: Text(s.editPasswordTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
              const SizedBox(height: 32),
              Text(
                s.changePasswordTitle,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 4, offset: Offset.zero,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LabelField(label: s.currentPasswordLabel),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _passSkrCtrl,
                      hint: s.currentPasswordHint,
                      lihat: _lihatSkr,
                      onToggle: () => setState(() => _lihatSkr = !_lihatSkr),
                    ),
                    const SizedBox(height: 16),
                    _LabelField(label: s.newPasswordLabel),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _passBrCtrl,
                      hint: s.newPasswordHint,
                      lihat: _lihatBr,
                      onToggle: () => setState(() => _lihatBr = !_lihatBr),
                    ),
                    const SizedBox(height: 16),
                    _LabelField(label: s.confirmNewPasswordLabel),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _konfirmasiCtrl,
                      hint: s.confirmNewPasswordHint,
                      lihat: _lihatKonfir,
                      onToggle: () =>
                          setState(() => _lihatKonfir = !_lihatKonfir),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(s.cancelButton, style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _sedangSimpan ? null : _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _sedangSimpan
                          ? const SizedBox(width: 18, height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(s.saveButton,
                              style: const TextStyle(fontSize: 14)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabelField extends StatelessWidget {
  final String label;
  const _LabelField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: const TextStyle(fontSize: 14, color: AppColors.textPrimary));
  }
}

class _InputPassword extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final bool lihat;
  final VoidCallback onToggle;

  const _InputPassword({
    required this.ctrl,
    required this.hint,
    required this.lihat,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: ctrl,
      obscureText: !lihat,
      keyboardType: TextInputType.visiblePassword,
      style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 14, color: AppColors.textHint),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black87, width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black87, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            lihat ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            size: 20, color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}