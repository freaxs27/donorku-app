import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Halaman Edit Password (P-001 varian Edit Password) — sesuai desain Figma.
class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final _passSkrCtrl  = TextEditingController();
  final _passBrCtrl   = TextEditingController();
  final _konfirmasiCtrl = TextEditingController();

  bool _lihatSkr    = false;
  bool _lihatBr     = false;
  bool _lihatKonfir = false;

  @override
  void dispose() {
    _passSkrCtrl.dispose();
    _passBrCtrl.dispose();
    _konfirmasiCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    final passSkr   = _passSkrCtrl.text.trim();
    final passBr    = _passBrCtrl.text.trim();
    final konfirm   = _konfirmasiCtrl.text.trim();

    if (passSkr.isEmpty || passBr.isEmpty || konfirm.isEmpty) {
      _tampilkanPesan('Semua field wajib diisi');
      return;
    }
    if (passBr != konfirm) {
      _tampilkanPesan('Password baru tidak cocok');
      return;
    }
    if (passBr.length < 8) {
      _tampilkanPesan('Password minimal 8 karakter');
      return;
    }

    // TODO: sambungkan ke API PUT /profil/password
    _tampilkanPesan('Password berhasil diubah');
    Navigator.of(context).pop();
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
              // Header
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

              // Form ubah password
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
                      onToggle: () =>
                          setState(() => _lihatSkr = !_lihatSkr),
                    ),
                    const SizedBox(height: 16),
                    _LabelField(label: 'Password Baru'),
                    const SizedBox(height: 6),
                    _InputPassword(
                      ctrl: _passBrCtrl,
                      hint: 'Masukkan password baru',
                      lihat: _lihatBr,
                      onToggle: () =>
                          setState(() => _lihatBr = !_lihatBr),
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

              // Tombol Batal + Simpan
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
                      child: const Text('Batal',
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Simpan',
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
        hintStyle: const TextStyle(
            fontSize: 14, color: AppColors.textHint),
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