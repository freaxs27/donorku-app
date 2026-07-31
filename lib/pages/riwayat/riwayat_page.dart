import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';

/// Halaman Riwayat Donor (RW-001).
class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  static const List<_FilterChipData> _filters = [
    _FilterChipData(id: 'all', label: 'ALL'),
    _FilterChipData(id: '1b', label: '1 Bulan Terakhir'),
    _FilterChipData(id: '6b', label: '6 Bulan Terakhir'),
    _FilterChipData(id: '1t', label: '1 Tahun Terakhir'),
  ];

  static final List<_ItemRiwayat> _semuaRiwayat = [
    _ItemRiwayat(
      tanggal: '5 Agustus 2025',
      lokasi: 'Rumah Sakit Kartini Bandung',
      volume: '450ml',
      status: 'Selesai',
      golonganDarah: 'O+',
      tanggalSort: DateTime(2025, 8, 5),
    ),
    _ItemRiwayat(
      tanggal: '20 Mei 2025',
      lokasi: 'Rumah Sakit Pasundan',
      volume: '450ml',
      status: 'Selesai',
      golonganDarah: 'O+',
      tanggalSort: DateTime(2025, 5, 20),
    ),
    _ItemRiwayat(
      tanggal: '10 Maret 2025',
      lokasi: 'Rumah Sakit Santo Boromeus',
      volume: '450ml',
      status: 'Selesai',
      golonganDarah: 'O+',
      tanggalSort: DateTime(2025, 3, 10),
    ),
    _ItemRiwayat(
      tanggal: '3 Januari 2025',
      lokasi: 'Rumah Sakit Veteran',
      volume: '450ml',
      status: 'Selesai',
      golonganDarah: 'O+',
      tanggalSort: DateTime(2025, 1, 3),
    ),
  ];

  String _filterAktif = 'all';

  List<_ItemRiwayat> get _riwayatTampil {
    if (_filterAktif == 'all') return _semuaRiwayat;
    final sekarang = DateTime.now();
    final Duration batas = switch (_filterAktif) {
      '1b' => const Duration(days: 30),
      '6b' => const Duration(days: 183),
      '1t' => const Duration(days: 365),
      _ => Duration.zero,
    };
    return _semuaRiwayat
        .where((r) => sekarang.difference(r.tanggalSort) <= batas)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppDimens.paddingL,
              AppDimens.paddingM,
              AppDimens.paddingL,
              0,
            ),
            child: HeaderHalaman(judul: 'Riwayat Donor'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.paddingL,
                20,
                AppDimens.paddingL,
                AppDimens.paddingL,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _KartuRingkasan(
                    totalDonasi: 8,
                    totalMl: 3600,
                  ),
                  const SizedBox(height: 12),
                  const _KartuDonorKembali(tanggal: '2 Februari 2026'),
                  const SizedBox(height: 16),
                  _BarisFilter(
                    filters: _filters,
                    aktif: _filterAktif,
                    onPilih: (id) => setState(() => _filterAktif = id),
                  ),
                  const SizedBox(height: 16),
                  const _KartuStatusKesehatan(
                    hemoglobin: '14.7',
                    tekananDarah: '120/80',
                    hasilTes: 'Negatif',
                  ),
                  const SizedBox(height: 12),
                  for (final item in _riwayatTampil) ...[
                    _KartuRiwayat(item: item),
                    const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _FilterChipData {
  final String id;
  final String label;
  const _FilterChipData({required this.id, required this.label});
}

class _ItemRiwayat {
  final String tanggal;
  final String lokasi;
  final String volume;
  final String status;
  final String golonganDarah;
  final DateTime tanggalSort;

  const _ItemRiwayat({
    required this.tanggal,
    required this.lokasi,
    required this.volume,
    required this.status,
    required this.golonganDarah,
    required this.tanggalSort,
  });
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

BoxDecoration get _dekorasiKartu => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 4,
          offset: Offset.zero,
        ),
      ],
    );

class _KartuRingkasan extends StatelessWidget {
  final int totalDonasi;
  final int totalMl;

  const _KartuRingkasan({
    required this.totalDonasi,
    required this.totalMl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '$totalDonasi',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text('Total Donasi', style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          ),
          Container(width: 1, height: 56, color: AppColors.border),
          Expanded(
            child: Column(
              children: [
                Text(
                  '$totalMl',
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text('ml Darah', style: AppTextStyles.caption.copyWith(fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuDonorKembali extends StatelessWidget {
  final String tanggal;

  const _KartuDonorKembali({required this.tanggal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined, size: 30, color: AppColors.textPrimary),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dapat Donor Kembali', style: AppTextStyles.body),
              const SizedBox(height: 2),
              Text(
                tanggal,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BarisFilter extends StatelessWidget {
  final List<_FilterChipData> filters;
  final String aktif;
  final ValueChanged<String> onPilih;

  const _BarisFilter({
    required this.filters,
    required this.aktif,
    required this.onPilih,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < filters.length; i++) ...[
            _ChipFilter(
              label: filters[i].label,
              isAktif: filters[i].id == aktif,
              onTap: () => onPilih(filters[i].id),
              sempit: filters[i].id == 'all',
            ),
            if (i != filters.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _ChipFilter extends StatelessWidget {
  final String label;
  final bool isAktif;
  final VoidCallback onTap;
  final bool sempit;

  const _ChipFilter({
    required this.label,
    required this.isAktif,
    required this.onTap,
    this.sempit = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 18,
        width: sempit ? 43 : 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isAktif ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: isAktif ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}

class _KartuStatusKesehatan extends StatelessWidget {
  final String hemoglobin;
  final String tekananDarah;
  final String hasilTes;

  const _KartuStatusKesehatan({
    required this.hemoglobin,
    required this.tekananDarah,
    required this.hasilTes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          Container(
            height: 26,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD8D8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/riwayat/tekanan_darah.png',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Status Kesehatan',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MiniMetrik(
                  iconAsset: 'assets/icons/riwayat/hemoglobin.png',
                  baris1: Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Hemoglobin\n',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: hemoglobin,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: ' g/dL',
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _MiniMetrik(
                  iconAsset: 'assets/icons/riwayat/tekanan_darah.png',
                  baris1: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: tekananDarah,
                          style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(
                          text: ' mmHg\n',
                          style: TextStyle(fontSize: 7, fontWeight: FontWeight.w400),
                        ),
                        const TextSpan(
                          text: 'Normal',
                          style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: _MiniMetrik(
                  iconAsset: 'assets/icons/riwayat/hasil_tes.png',
                  baris1: Text(
                    hasilTes,
                    style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMetrik extends StatelessWidget {
  final String iconAsset;
  final Widget baris1;

  const _MiniMetrik({
    required this.iconAsset,
    required this.baris1,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 2,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(iconAsset, width: 18, height: 18),
          const SizedBox(width: 4),
          Expanded(child: baris1),
        ],
      ),
    );
  }
}

class _KartuRiwayat extends StatelessWidget {
  final _ItemRiwayat item;

  const _KartuRiwayat({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 99),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          // Icon Blood — Figma 66px + inset −6% ≈ 74px visual
          SizedBox(
            width: 74,
            height: 74,
            child: SvgPicture.asset(
              'assets/icons/riwayat/blood_drop.svg',
              width: 74,
              height: 74,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.tanggal,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.lokasi,
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Gol dar — Figma 43×21, font 10; sedikit diperbesar
                    Container(
                      width: 48,
                      height: 24,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Text(
                        item.golonganDarah,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      item.volume,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 36),
                    Text(
                      item.status,
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
