// ignore_for_file: unnecessary_underscores, unused_element_parameter

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../model/data_profil.dart';
import '../../services/profil/profil_service.dart';
import '../../services/core/api_exception.dart';

class EditProfilPage extends StatefulWidget {
  final DataProfil data;
  const EditProfilPage({super.key, required this.data});

  @override
  State<EditProfilPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  late final TextEditingController _namaCtrl;
  late final TextEditingController _noTelpCtrl;
  late final TextEditingController _alamatCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _golDarahCtrl;

  // Tanggal lahir disimpan sebagai DateTime terpisah, bukan dari controller
  late DateTime _tanggalLahir;

  final ProfilService _service = ProfilService();
  bool _sedangSimpan = false;
  File? _fotoBaruDipilih; // foto baru dari galeri (belum diupload)

  @override
  void initState() {
    super.initState();
    _namaCtrl     = TextEditingController(text: widget.data.namaLengkap);
    _noTelpCtrl   = TextEditingController(text: widget.data.noHp ?? '');
    _alamatCtrl   = TextEditingController(text: widget.data.alamat ?? '');
    _emailCtrl    = TextEditingController(text: widget.data.email);
    _golDarahCtrl = TextEditingController(text: widget.data.golonganDarah);
    _tanggalLahir = widget.data.tanggalLahir;
  }

  @override
  void dispose() {
    _namaCtrl.dispose();
    _noTelpCtrl.dispose();
    _alamatCtrl.dispose();
    _emailCtrl.dispose();
    _golDarahCtrl.dispose();
    super.dispose();
  }

  Future<void> _pilihFoto() async {
    final picker = ImagePicker();
    final hasil = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (hasil != null && mounted) {
      setState(() => _fotoBaruDipilih = File(hasil.path));
    }
  }

  Future<void> _pilihTanggalLahir() async {
    final hasil = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir,
      firstDate: DateTime(1940),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 17)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (hasil != null) setState(() => _tanggalLahir = hasil);
  }

  String get _tanggalLahirFormat =>
      '${_tanggalLahir.day} - ${_tanggalLahir.month} - ${_tanggalLahir.year}';

  Future<void> _simpan() async {
    final s = AppStrings.of(context);
    if (_namaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.fullNameRequired)));
      return;
    }

    final goldar = _golDarahCtrl.text.trim().toUpperCase();
    if (goldar.isNotEmpty &&
        !RegExp(r'^(A|B|AB|O)[+-]$').hasMatch(goldar)) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(s.bloodTypeFormatInvalid)));
      return;
    }

    setState(() => _sedangSimpan = true);
    try {
      // Upload foto dulu kalau ada foto baru dipilih
      if (_fotoBaruDipilih != null) {
        await _service.uploadFotoProfil(_fotoBaruDipilih!);
      }

      // Update data profil teks
      final dataUpdate = <String, String>{
        'nama_lengkap': _namaCtrl.text.trim(),
        'no_hp': _noTelpCtrl.text.trim(),
        'alamat': _alamatCtrl.text.trim(),
        'email': _emailCtrl.text.trim(),
        'tanggal_lahir':
            '${_tanggalLahir.year}-${_tanggalLahir.month.toString().padLeft(2, '0')}-${_tanggalLahir.day.toString().padLeft(2, '0')}',
      };
      if (goldar.isNotEmpty) dataUpdate['golongan_darah'] = goldar;

      await _service.updateProfil(dataUpdate);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.profileUpdated)));
        Navigator.of(context).pop();
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(s.saveFailed)));
      }
    } finally {
      if (mounted) setState(() => _sedangSimpan = false);
    }
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
                    child: Text(s.editProfileTitle,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
              const SizedBox(height: 24),

              // Foto profil — tap ikon pensil untuk ganti dari galeri
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 120, height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: const Color(0xFFFFD8D8),
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(13),
                        child: _fotoBaruDipilih != null
                            ? Image.file(_fotoBaruDipilih!,
                                fit: BoxFit.cover, width: 120, height: 120)
                            : widget.data.fotoProfil != null
                                ? Image.network(widget.data.fotoProfil!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.person,
                                        size: 56, color: AppColors.primary))
                                : const Icon(Icons.person,
                                    size: 56, color: AppColors.primary),
                      ),
                    ),
                    Positioned(
                      bottom: 0, right: 0,
                      child: GestureDetector(
                        onTap: _pilihFoto,
                        child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.border),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 4),
                            ],
                          ),
                          child: const Icon(Icons.edit,
                              size: 16, color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Statistik
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
                            blurRadius: 4, offset: Offset.zero),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${widget.data.totalDonasi}',
                                  style: const TextStyle(fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              const SizedBox(height: 2),
                              Text(s.totalDonations,
                                  style: const TextStyle(fontSize: 10,
                                      color: AppColors.textPrimary)),
                            ],
                          ),
                        ),
                        Container(width: 1, height: 34, color: AppColors.border),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${widget.data.totalMlDarah}',
                                  style: const TextStyle(fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary)),
                              const SizedBox(height: 2),
                              Text(s.mlBlood,
                                  style: const TextStyle(fontSize: 10,
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

              // Form
              Text(s.personalInfoSection,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary)),
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
                        blurRadius: 4, offset: Offset.zero),
                  ],
                ),
                child: Column(
                  children: [
                    // Nama Lengkap — bisa diedit
                    _BarisEdit(label: s.fullNameLabel, ctrl: _namaCtrl),
                    const Divider(height: 1, color: AppColors.border),

                    _BarisEdit(label: s.phoneProfilLabel, ctrl: _noTelpCtrl,
                        tipe: TextInputType.phone),
                    const Divider(height: 1, color: AppColors.border),

                    _BarisTanggalLahir(
                      label: s.dobLabel,
                      nilai: _tanggalLahirFormat,
                      onTap: _pilihTanggalLahir,
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    _BarisEdit(label: s.addressLabel, ctrl: _alamatCtrl, maxLines: 2),
                    const Divider(height: 1, color: AppColors.border),

                    _BarisEdit(label: s.emailLabel, ctrl: _emailCtrl,
                        tipe: TextInputType.emailAddress),
                    const Divider(height: 1, color: AppColors.border),

                    _BarisGolonganDarah(ctrl: _golDarahCtrl, hint: s.bloodTypeExampleHint, label: s.bloodTypeLabel),
                  ],
                ),
              ),
              const SizedBox(height: 20),

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
                      child: Text(s.cancelButton,
                          style: const TextStyle(fontSize: 14)),
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
                                  strokeWidth: 2, color: Colors.white))
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

// ---------------------------------------------------------------------------
// Baris field editable biasa
// ---------------------------------------------------------------------------
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
                style: TextStyle(
                    fontSize: 14,
                    color: readOnly
                        ? AppColors.textSecondary
                        : AppColors.textPrimary)),
          ),
          Text(': ',
              style: TextStyle(
                  fontSize: 14,
                  color: readOnly
                      ? AppColors.textSecondary
                      : AppColors.textPrimary)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: TextField(
                controller: ctrl,
                readOnly: readOnly,
                maxLines: maxLines,
                keyboardType: tipe,
                style: TextStyle(
                    fontSize: 14,
                    color: readOnly
                        ? AppColors.textSecondary
                        : AppColors.textPrimary),
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

// ---------------------------------------------------------------------------
// Baris tanggal lahir — tap buka date picker
// ---------------------------------------------------------------------------
class _BarisTanggalLahir extends StatelessWidget {
  final String label;
  final String nilai;
  final VoidCallback onTap;

  const _BarisTanggalLahir({required this.label, required this.nilai, required this.onTap});

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
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: GestureDetector(
                onTap: onTap,
                child: AbsorbPointer(
                  child: TextField(
                    controller: TextEditingController(text: nilai),
                    readOnly: true,
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
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Baris golongan darah — bisa diedit, pakai formatter +/-
// ---------------------------------------------------------------------------
class _BarisGolonganDarah extends StatelessWidget {
  final TextEditingController ctrl;
  final String hint;
  final String label;

  const _BarisGolonganDarah({required this.ctrl, required this.hint, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          ),
          const Text(': ',
              style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 4),
              child: TextField(
                controller: ctrl,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [_FormatGolonganDarah()],
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: hint,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Formatter golongan darah — sama persis dengan di foto_ktp_page.dart
// ---------------------------------------------------------------------------
class _FormatGolonganDarah extends TextInputFormatter {
  static final _polaValid =
      RegExp(r'^(A|B|AB|O)?[+-]?$', caseSensitive: false);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final teks = newValue.text.toUpperCase();
    if (_polaValid.hasMatch(teks)) {
      return newValue.copyWith(text: teks);
    }
    return oldValue;
  }
}