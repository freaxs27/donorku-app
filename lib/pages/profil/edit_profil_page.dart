import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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
    if (_namaCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama lengkap tidak boleh kosong')));
      return;
    }

    final goldar = _golDarahCtrl.text.trim().toUpperCase();
    if (goldar.isNotEmpty &&
        !RegExp(r'^(A|B|AB|O)[+-]$').hasMatch(goldar)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Golongan darah harus diakhiri + atau - (contoh: O+, AB-)')));
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
            const SnackBar(content: Text('Profil berhasil diperbarui')));
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
            const SnackBar(content: Text('Gagal menyimpan, coba lagi.')));
      }
    } finally {
      if (mounted) setState(() => _sedangSimpan = false);
    }
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
                    child: Text('Edit Profil',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                  ),
                  const Icon(Icons.settings_outlined,
                      size: 26, color: AppColors.textPrimary),
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
                                    errorBuilder: (_, _, _) => const Icon(
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
                              const Text('Total Donasi',
                                  style: TextStyle(fontSize: 10,
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
                              const Text('ml Darah',
                                  style: TextStyle(fontSize: 10,
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
              const Text('Informasi Pribadi',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
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
                    _BarisEdit(label: 'Nama Lengkap', ctrl: _namaCtrl),
                    const Divider(height: 1, color: AppColors.border),

                    // No Telepon — bisa diedit
                    _BarisEdit(label: 'No Telepon', ctrl: _noTelpCtrl,
                        tipe: TextInputType.phone),
                    const Divider(height: 1, color: AppColors.border),

                    // Tanggal Lahir — tap buka date picker
                    _BarisTanggalLahir(
                      nilai: _tanggalLahirFormat,
                      onTap: _pilihTanggalLahir,
                    ),
                    const Divider(height: 1, color: AppColors.border),

                    // Alamat — bisa diedit
                    _BarisEdit(label: 'Alamat', ctrl: _alamatCtrl, maxLines: 2),
                    const Divider(height: 1, color: AppColors.border),

                    // Email — bisa diedit
                    _BarisEdit(label: 'Email', ctrl: _emailCtrl,
                        tipe: TextInputType.emailAddress),
                    const Divider(height: 1, color: AppColors.border),

                    // Golongan Darah — textfield dengan formatter, ketik manual
                    _BarisGolonganDarah(ctrl: _golDarahCtrl),
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
                      child: const Text('Batal',
                          style: TextStyle(fontSize: 14)),
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
    this.maxLines = 1,
  }) : readOnly = false;

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
  final String nilai;
  final VoidCallback onTap;

  const _BarisTanggalLahir({required this.nilai, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            const SizedBox(
              width: 110,
              child: Text('Tanggal Lahir',
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            ),
            const Text(': ',
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(nilai,
                  style: const TextStyle(
                      fontSize: 14, color: AppColors.textPrimary)),
            ),
            const Icon(Icons.calendar_today_outlined,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Baris golongan darah — bisa diedit, pakai formatter +/-
// ---------------------------------------------------------------------------
class _BarisGolonganDarah extends StatelessWidget {
  final TextEditingController ctrl;

  const _BarisGolonganDarah({required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          const SizedBox(
            width: 110,
            child: Text('Golongan Darah',
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
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
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  hintText: 'Contoh: O+',
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