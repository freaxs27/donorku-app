import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../../../theme/app_theme.dart';
import '../../../model/data_register.dart';
import 'foto_diri_page.dart';

// (R-002).
class FotoKtpPage extends StatefulWidget {
  final DataRegister data;

  const FotoKtpPage({super.key, required this.data});

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
      final nikMatch =
          RegExp(r'\d{15,16}').firstMatch(hasil.text.replaceAll(' ', ''));
      final barisTersusun = _rekonstruksiBarisBerdasarkanPosisi(hasil);
      _isiOtomatisDariOcr(barisTersusun, nikMatch?.group(0));
    } catch (e) {
      debugPrint('OCR gagal: $e');
    } finally {
      if (mounted) setState(() => _sedangMemproses = false);
    }
  }

  List<String> _rekonstruksiBarisBerdasarkanPosisi(RecognizedText hasil) {
    final semuaBaris = <TextLine>[];
    for (final block in hasil.blocks) {
      semuaBaris.addAll(block.lines);
    }

    semuaBaris.sort((a, b) => a.boundingBox.top.compareTo(b.boundingBox.top));

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

    return grup.map((g) {
      g.sort((a, b) => a.boundingBox.left.compareTo(b.boundingBox.left));
      return g.map((l) => l.text).join(' ');
    }).toList();
  }

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
    final nik = _nikController.text.trim();
    final ttlText = _ttlController.text.trim();
    final alamat = _alamatController.text.trim();
    final goldar = _goldarController.text.trim();
    final profesi = _profesiController.text.trim();

    if (nik.length != 16 || int.tryParse(nik) == null) {
      _tampilkanPesan('NIK harus 16 digit angka');
      return;
    }

    final tanggalLahir = _parseTanggalLahir(ttlText);
    if (tanggalLahir == null) {
      _tampilkanPesan('Format TTL tidak dikenali, coba edit manual (contoh: 28-06-2006)');
      return;
    }

    if (alamat.isEmpty || goldar.isEmpty || profesi.isEmpty) {
      _tampilkanPesan('Lengkapi semua data hasil scan KTP dulu');
      return;
    }

    final jenisKelamin = _tentukanJenisKelaminDariNik(nik);

    final dataLengkap = widget.data.copyWith(
      nik: nik,
      tanggalLahir: tanggalLahir,
      alamat: alamat,
      golonganDarah: goldar,
      profesi: profesi,
      jenisKelamin: jenisKelamin,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FotoDiriPage(data: dataLengkap)),
    );
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  String _tentukanJenisKelaminDariNik(String nik) {
    final tanggalDigit = int.tryParse(nik.substring(6, 8)) ?? 0;
    return tanggalDigit > 40 ? 'Perempuan' : 'Laki-laki';
  }

  DateTime? _parseTanggalLahir(String teks) {
    if (teks.isEmpty) return null;

    final bagian = teks.split(',');
    final tanggalSaja = (bagian.length > 1 ? bagian.last : teks).trim();

    final polaAngka = RegExp(r'(\d{1,2})[-/](\d{1,2})[-/](\d{2,4})');
    final cocokAngka = polaAngka.firstMatch(tanggalSaja);
    if (cocokAngka != null) {
      final tgl = int.parse(cocokAngka.group(1)!);
      final bln = int.parse(cocokAngka.group(2)!);
      var thn = int.parse(cocokAngka.group(3)!);
      if (thn < 100) thn += 2000; 
      try {
        return DateTime(thn, bln, tgl);
      } catch (_) {
        return null;
      }
    }

    const namaBulan = [
      'januari', 'februari', 'maret', 'april', 'mei', 'juni',
      'juli', 'agustus', 'september', 'oktober', 'november', 'desember',
    ];
    final polaNamaBulan = RegExp(r'(\d{1,2})\s+([a-zA-Z]+)\s+(\d{4})');
    final cocokNama = polaNamaBulan.firstMatch(tanggalSaja);
    if (cocokNama != null) {
      final idxBulan = namaBulan.indexOf(cocokNama.group(2)!.toLowerCase());
      if (idxBulan != -1) {
        try {
          return DateTime(int.parse(cocokNama.group(3)!), idxBulan + 1, int.parse(cocokNama.group(1)!));
        } catch (_) {
          return null;
        }
      }
    }

    return null;
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