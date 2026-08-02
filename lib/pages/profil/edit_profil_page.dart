import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Halaman Edit Profil (P-001 varian Edit) — sesuai desain Figma.
class EditProfilPage extends StatefulWidget {
  const EditProfilPage({super.key});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  final _namaCtrl       = TextEditingController(text: 'Kaka Muhamad Ridwan');
  final _noTelpCtrl     = TextEditingController(text: '081253041346');
  final _tglLahirCtrl   = TextEditingController(text: '28 - 6 - 2006');
  final _alamatCtrl     = TextEditingController(text: 'Wado, Sumedang');
  final _emailCtrl      = TextEditingController(text: 'kakamr@gmail.com');
  final _golDarahCtrl   = TextEditingController(text: 'O+');

  @override
  void dispose() {
    _namaCtrl.dispose();
    _noTelpCtrl.dispose();
    _tglLahirCtrl.dispose();
    _alamatCtrl.dispose();
    _emailCtrl.dispose();
    _golDarahCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    // TODO: sambungkan ke API PUT /profil
    Navigator.of(context).pop();
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
                      'Edit Profil',
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
              const SizedBox(height: 24),

              // Foto profil dengan ikon edit
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFFFD8D8),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.person,
                          size: 56, color: AppColors.primary),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.border, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: const Icon(Icons.edit,
                            size: 16, color: AppColors.textPrimary),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Statistik — sama dengan profil page, IntrinsicWidth
              Center(
                child: IntrinsicWidth(
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 4,
                          offset: Offset.zero,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('8',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              SizedBox(height: 2),
                              Text('Total Donasi',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 34, color: AppColors.border),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text('829',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              SizedBox(height: 2),
                              Text('ml Darah',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Form informasi pribadi
              const Text(
                'Informasi Pribadi',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
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
                  children: [
                    _BarisEdit(label: 'Nama Lengkap', ctrl: _namaCtrl),
                    const Divider(height: 1, color: AppColors.border),
                    _BarisEdit(label: 'No Telepon', ctrl: _noTelpCtrl,
                        tipe: TextInputType.phone),
                    const Divider(height: 1, color: AppColors.border),
                    _BarisEdit(label: 'Tanggal Lahir', ctrl: _tglLahirCtrl,
                        readOnly: true),
                    const Divider(height: 1, color: AppColors.border),
                    _BarisEdit(label: 'Alamat', ctrl: _alamatCtrl,
                        maxLines: 2),
                    const Divider(height: 1, color: AppColors.border),
                    _BarisEdit(label: 'Email', ctrl: _emailCtrl,
                        tipe: TextInputType.emailAddress),
                    const Divider(height: 1, color: AppColors.border),
                    _BarisEdit(label: 'Golongan Darah',
                        ctrl: _golDarahCtrl, readOnly: true),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Tombol Ganti Password + Simpan
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

class _BarisEdit extends StatelessWidget {
  final String label;
  final TextEditingController ctrl;
  final TextInputType tipe;
  final bool readOnly;
  final int maxLines;

  const _BarisEdit({
    required this.label,
    required this.ctrl,
    this.tipe = TextInputType.text,
    this.readOnly = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary)),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: TextField(
                controller: ctrl,
                readOnly: readOnly,
                maxLines: maxLines,
                keyboardType: tipe,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}