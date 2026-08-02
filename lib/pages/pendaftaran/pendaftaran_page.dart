import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../services/core/api_config.dart';
import 'jadwal_lokasi_page.dart';

/// Halaman Pendaftaran / Daftar - Step 1 (D-001).
/// Aturan & Tips Donor, dengan tombol lampu di kanan atas yang membuka
/// modal Edukasi & Manfaat Donor (DE-001).
class PendaftaranPage extends StatefulWidget {
  const PendaftaranPage({super.key});

  @override
  State<PendaftaranPage> createState() => _PendaftaranPageState();
}

class _PendaftaranPageState extends State<PendaftaranPage> {
  List<_ItemAturan> _aturanList = [];
  List<_ItemAturan> _tipsList = [];
  bool _sedangMemuat = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    try {
      final uri = Uri.parse('${ApiConfig.baseUrl}/edukasi');
      final response = await http.get(uri).timeout(const Duration(seconds: 20));
      if (response.statusCode == 200) {
        final list = jsonDecode(response.body) as List<dynamic>;
        final aturan = <_ItemAturan>[];
        final tips = <_ItemAturan>[];
        for (final item in list) {
          final judul = item['judul'] as String? ?? '';
          final isi = item['isi'] as String? ?? '';
          final kategori = (item['kategori'] as String? ?? '').toLowerCase();
          // Split isi per baris untuk dijadikan sub-item bullet
          final subItem = isi
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
          final itemAturan = _ItemAturan(judul, subItem);
          if (kategori == 'aturan') {
            aturan.add(itemAturan);
          } else {
            tips.add(itemAturan);
          }
        }
        if (mounted) {
          setState(() {
            _aturanList = aturan;
            _tipsList = tips;
            _sedangMemuat = false;
          });
        }
      } else {
        if (mounted) setState(() => _sedangMemuat = false);
      }
    } catch (_) {
      if (mounted) setState(() => _sedangMemuat = false);
    }
  }

  void _bukaEdukasi(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => const _ModalEdukasiDonor(),
    );
  }

  void _mulaiDonor(BuildContext context) {
    // Push biasa saja -- bottom nav otomatis tetap ada karena MainLayout
    // sekarang kasih tiap tab Navigator sendiri (lihat main_layout.dart).
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const JadwalLokasiPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: _sedangMemuat
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 12, AppDimens.paddingL, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HeaderHalaman(
                          judul: 'Aturan dan Tips Donor',
                          trailing: GestureDetector(
                            onTap: () => _bukaEdukasi(context),
                            child: Image.asset('assets/icons/edukasi/lamp.png', width: 24, height: 24),
                          ),
                        ),
                        const SizedBox(height: 14),

                        if (_aturanList.isNotEmpty) ...[
                          _KartuAturan(
                            judul: 'Aturan sebelum donor darah :',
                            items: _aturanList,
                          ),
                          const SizedBox(height: 12),
                        ],

                        if (_tipsList.isNotEmpty)
                          _KartuAturan(
                            judul: 'Tips sebelum donor darah :',
                            items: _tipsList,
                          ),
                      ],
                    ),
                  ),
          ),

          // Tombol fixed di bawah layar, selalu kelihatan tanpa perlu scroll.
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 0, AppDimens.paddingL, 16),
            child: ElevatedButton(
              onPressed: () => _mulaiDonor(context),
              child: const Text('Donor Sekarang'),
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemAturan {
  final String judul;
  final List<String> subItem;
  const _ItemAturan(this.judul, this.subItem);
}

class _KartuAturan extends StatelessWidget {
  final String judul;
  final List<_ItemAturan> items;

  const _KartuAturan({required this.judul, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 7),
          for (int i = 0; i < items.length; i++) ...[
            _baris1Utama(i + 1, items[i].judul),
            ...items[i].subItem.map(_barisSub),
            if (i != items.length - 1) const SizedBox(height: 5),
          ],
        ],
      ),
    );
  }

  Widget _baris1Utama(int nomor, String teks) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text('$nomor. $teks', style: const TextStyle(fontSize: 12)),
    );
  }

  Widget _barisSub(String teks) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•  ', style: TextStyle(fontSize: 10.5, color: AppColors.textSecondary)),
          Expanded(
            child: Text(
              teks,
              style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary, height: 1.28),
            ),
          ),
        ],
      ),
    );
  }
}

/// Modal Edukasi & Manfaat Donor (DE-001).
class _ModalEdukasiDonor extends StatelessWidget {
  const _ModalEdukasiDonor();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset('assets/icons/edukasi/book.png', width: 22, height: 22),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Edukasi & Manfaat Donor', style: AppTextStyles.subheading),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _KartuEdukasi(
                judul: 'Edukasi Donor Darah',
                items: const [
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/shield.png',
                    judul: 'Donor Darah Aman',
                    deskripsi: 'Proses menggunakan alat steril sekali pakai dan diawasi tenaga medis.',
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/syarat.png',
                    judul: 'Memenuhi Syarat Kesehatan',
                    deskripsi: 'Sebelum donor, pendonor akan diperiksa kondisi umum untuk memastikan tubuh dalam keadaan sehat.',
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/rutin.png',
                    judul: 'Donor Dilakukan Secara Rutin',
                    deskripsi: 'Donor darah bisa dilakukan setiap 2-3 bulan sekali untuk menjaga ketersediaan stok darah bagi yang membutuhkan.',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _KartuEdukasi(
                judul: 'Manfaat Donor Darah',
                items: const [
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/jantung.png',
                    judul: 'Menjaga Kesehatan Jantung',
                    deskripsi: 'Donor darah membantu menjaga kekentalan darah tetap stabil',
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/deteksi.png',
                    judul: 'Deteksi Penyakit Serius',
                    deskripsi: 'Sebelum donor, dilakukan pemeriksaan kesehatan, sehingga dapat mengetahui kondisi kesehatan sejak awal.',
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/produksi.png',
                    judul: 'Meningkatkan Produksi Sel Darah Baru',
                    deskripsi: 'Setelah donor, tubuh akan merangsang pembentukan sel darah merah baru untuk menggantikan yang hilang',
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

class _ItemEdukasi {
  final String iconAsset;
  final String judul;
  final String deskripsi;
  const _ItemEdukasi({required this.iconAsset, required this.judul, required this.deskripsi});
}

class _KartuEdukasi extends StatelessWidget {
  final String judul;
  final List<_ItemEdukasi> items;

  const _KartuEdukasi({required this.judul, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(judul, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          for (int i = 0; i < items.length; i++) ...[
            _baris(items[i]),
            if (i != items.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }

  Widget _baris(_ItemEdukasi item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(item.iconAsset, width: 24, height: 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.judul, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Text(item.deskripsi, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}