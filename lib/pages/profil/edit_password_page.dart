import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/validators/app_validators.dart';
import '../../services/profil/profil_service.dart';
import '../../services/core/api_exception.dart';

/// Halaman Edit Password (P-001 varian Edit Password) — sesuai desain Figma.
class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _passSkrCtrl = TextEditingController();
  final _passBrCtrl = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();
  final ProfilService _service = ProfilService();

  bool _lihatSkr = false;
  bool _lihatBr = false;
  bool _lihatKonfir = false;
  bool _sedangSimpan = false;

  @override
  void dispose() {
    _passSkrCtrl.dispose();
    _passBrCtrl.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    final passSkr = _passSkrCtrl.text;
    final passBr = _passBrCtrl.text;
    final konfirm = _konfirmasiCtrl.text;

    if (passSkr.isEmpty || passBr.isEmpty || konfirm.isEmpty) {
      _tampilkanPesan('Semua field wajib diisi');
      return;
    }
    final errPass = AppValidators.password(passBr);
    if (errPass != null) {
      _tampilkanPesan(errPass);
      return;
    }
    final errKonfirm = AppValidators.passwordConfirm(passBr, konfirm);
    if (errKonfirm != null) {
      _tampilkanPesan(errKonfirm);
      return;
    }

    setState(() => _sedangSimpan = true);
    try {
      await _service.gantiPassword(
        passwordSekarang: passSkr,
        passwordBaru: passBr,
        konfirmasiPasswordBaru: konfirm,
      );
      if (!mounted) return;
      _tampilkanPesan('Password berhasil diubah');
      Navigator.of(context).pop();
    } on ApiException catch (e) {
      if (e.statusCode == 401) return;
      if (mounted) _tampilkanPesan(e.message);
    } catch (_) {
      if (mounted) _tampilkanPesan('Gagal mengubah password, coba lagi.');
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
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.arrow_back,
                        size: 28, color: AppColors.textPrimary),
                  ),
                  const Expanded(
                    child: Text(
                      'Edit Password',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary),
                    ),
                  ),
                  const Icon(Icons.settings_outlined,
                      size: 26, color: AppColors.textPrimary),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Ubah Password',
                style: TextStyle(
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
                      blurRadius: 4,
                      offset: Offset.zero,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _LabelField(label: 'Password Saat Ini'),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _passSkrCtrl,
                      hint: 'Masukkan password sekarang',
                      lihat: _lihatSkr,
                      onToggle: () => setState(() => _lihatSkr = !_lihatSkr),
                    ),
                    const SizedBox(height: 16),
                    _LabelField(label: 'Password Baru'),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _passBrCtrl,
                      hint: 'Masukkan password baru',
                      lihat: _lihatBr,
                      onToggle: () => setState(() => _lihatBr = !_lihatBr),
                    ),
                    const SizedBox(height: 16),
                    _LabelField(label: 'Konfirmasi Password Baru'),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _konfirmasiCtrl,
                      hint: 'Masukkan kembali password baru',
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
                      onPressed: _sedangSimpan
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Batal', style: TextStyle(fontSize: 14)),
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
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('Simpan',
                              style: TextStyle(fontSize: 14)),
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
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary));
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
            size: 20,
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
