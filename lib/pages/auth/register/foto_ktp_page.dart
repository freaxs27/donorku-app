import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../theme/app_theme.dart';
import 'foto_diri_page.dart';

// (R-002).
class FotoKtpPage extends StatefulWidget {
  const FotoKtpPage({super.key});

  @override
  State<FotoKtpPage> createState() => _FotoKtpPageState();
}

class _FotoKtpPageState extends State<FotoKtpPage> {
  File? _fotoKtp;
  bool _sedangMemproses = false;

  final TextRecognizer _textRecognizer =
      TextRecognizer(script: TextRecognitionScript.latin);

  final TextEditingController _nikController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _ttlController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _goldarController = TextEditingController();
  final TextEditingController _profesiController = TextEditingController();

  @override
  void dispose() {
    _textRecognizer.close();
    _nikController.dispose();
    _namaController.dispose();
    _ttlController.dispose();
    _alamatController.dispose();
    _goldarController.dispose();
    _profesiController.dispose();
    super.dispose();
  }

  Future<void> _ambilFotoKtp() async {
    final picker = ImagePicker();
    final XFile? foto = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (foto == null) return; 

    setState(() {
      _fotoKtp = File(foto.path);
      _sedangMemproses = true;
    });

    try {
      final inputImage = InputImage.fromFilePath(foto.path);
      final RecognizedText hasil = await _textRecognizer.processImage(inputImage);

      // NIK dicari dari seluruh teks mentah (pola 15-16 digit angka),
      // ini tidak bergantung posisi/urutan baca, jadi paling stabil.
      final nikMatch =
          RegExp(r'\d{15,16}').firstMatch(hasil.text.replaceAll(' ', ''));

      // Field lainnya (Nama, TTL, dst.) dicari dari baris yang sudah
      // disusun ulang berdasarkan koordinat asli di foto, bukan urutan
      // baca ML Kit (yang sering salah urutan untuk layout kolom KTP).
      final barisTersusun = _rekonstruksiBarisBerdasarkanPosisi(hasil);
      _isiOtomatisDariOcr(barisTersusun, nikMatch?.group(0));
    } catch (e) {
      // Kalau OCR gagal (misal foto buram), field tetap kosong,
      // user bisa isi manual sendiri.
      debugPrint('OCR gagal: $e');
    } finally {
      if (mounted) setState(() => _sedangMemproses = false);
    }
  }

  /// Menyusun ulang semua baris teks hasil OCR berdasarkan POSISI ASLI
  /// di foto (koordinat Y untuk menentukan baris, koordinat X untuk
  /// urutan kiri-ke-kanan dalam baris yang sama).
  ///
  /// Ini penting karena ML Kit kadang membaca KTP per "blok" teks
  /// (misal semua label duluan, baru semua isi kolom kanan), bukan
  /// baris-per-baris sesuai tampilan visualnya. Dengan menyusun ulang
  /// pakai koordinat, label & isinya yang sebaris secara visual akan
  /// tergabung jadi satu baris logika juga.
  List<String> _rekonstruksiBarisBerdasarkanPosisi(RecognizedText hasil) {
    // Kumpulkan semua baris (TextLine) dari semua block, beserta posisinya.
    final semuaBaris = <TextLine>[];
    for (final block in hasil.blocks) {
      semuaBaris.addAll(block.lines);
    }

    // Urutkan dulu dari atas ke bawah (posisi Y).
    semuaBaris.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

    // Kelompokkan baris-baris yang posisi Y-nya berdekatan (dianggap
    // "sebaris" secara visual) jadi 1 grup.
    final List<List<TextLine>> grup = [];
    for (final baris in semuaBaris) {
      final tinggiBaris = baris.boundingBox.height;
      bool masukGrup = false;
      for (final g in grup) {
        final referensi = g.first.boundingBox;
        final bedaY = (baris.boundingBox.top - referensi.top).abs();
        if (bedaY < tinggiBaris * 0.6) {
          g.add(baris);
          masukGrup = true;
          break;
        }
      }
      if (!masukGrup) grup.add([baris]);
    }

    // Dalam tiap grup (baris visual yang sama), urutkan kiri ke kanan
    // berdasarkan posisi X, lalu gabung jadi 1 string.
    return grup.map((g) {
      g.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
      return g.map((l) => l.text).join(' ');
    }).toList();
  }

  /// Parsing baris-baris (yang sudah disusun ulang sesuai posisi visual)
  /// jadi field-field KTP, dengan mencari baris yang mengandung label
  /// tertentu (NAMA, LAHIR, dst.), lalu mengambil teks setelah label itu.
  void _isiOtomatisDariOcr(List<String> baris, String? nik) {
    String? cariNilai(List<String> label) {
      for (final line in baris) {
        final upper = line.toUpperCase();
        for (final l in label) {
          if (upper.contains(l)) {
            final idx = upper.indexOf(l);
            String sisa = line.substring(idx + l.length).trim();
            sisa = sisa.replaceFirst(RegExp(r'^[:\-\s]+'), '').trim();
            if (sisa.isNotEmpty) return sisa;
          }
        }
      }
      return null;
    }

    setState(() {
      if (nik != null) _nikController.text = nik;
      _namaController.text = cariNilai(['NAMA']) ?? _namaController.text;
      _ttlController.text = cariNilai(['LAHIR']) ?? _ttlController.text;
      _alamatController.text = cariNilai(['ALAMAT']) ?? _alamatController.text;
      _goldarController.text = cariNilai(['GOL. DARAH', 'GOL DARAH', 'GOLDAR']) ??
          _goldarController.text;
      _profesiController.text =
          cariNilai(['PEKERJAAN', 'PROFESI']) ?? _profesiController.text;
    });
  }

  void _lanjutkan() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const FotoDiriPage()),
    );
  }

  Widget _buildFieldHasilOcr(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          ),
          const Text(': ', style: AppTextStyles.body),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                isDense: true,
                filled: false,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: '-',
              ),
            ),
          ),
        ],
      ),
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

            const Text('Fotokan KTPmu atau e-ktp', style: AppTextStyles.subheading),
            const SizedBox(height: 12),

            // Kotak kamera / preview foto KTP
            GestureDetector(
              onTap: _sedangMemproses ? null : _ambilFotoKtp,
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
                    : _fotoKtp != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(AppDimens.radiusM),
                            child: Image.file(_fotoKtp!, fit: BoxFit.cover, width: double.infinity),
                          )
                        : const Center(
                            child: Icon(Icons.camera_alt_outlined, size: 48, color: Colors.black),
                          ),
              ),
            ),
            const SizedBox(height: 20),

            // Field hasil OCR (bisa diedit manual kalau ada yang salah baca)
            _buildFieldHasilOcr('NIK', _nikController),
            _buildFieldHasilOcr('Nama', _namaController),
            _buildFieldHasilOcr('TTL', _ttlController),
            _buildFieldHasilOcr('Alamat', _alamatController),
            _buildFieldHasilOcr('Goldar', _goldarController),
            _buildFieldHasilOcr('Profesi', _profesiController),
            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: _lanjutkan,
              child: const Text('Selanjutnya'),
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