import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../model/lokasi_donor.dart';
import 'donor_sukses_page.dart';

// (D-004)
class DonorKonfirmasiPage extends StatelessWidget {
  final DateTime? tanggalDonor;
  final LokasiDonor? lokasiDonor;
  final List<String> pertanyaan;
  final List<bool> jawaban;

  const DonorKonfirmasiPage({
    super.key,
    required this.tanggalDonor,
    required this.lokasiDonor,
    required this.pertanyaan,
    required this.jawaban,
  });

  static const List<String> _namaBulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  String _formatTanggal(DateTime? t) {
    if (t == null) return '-';
    return '${t.day} ${_namaBulan[t.month - 1]} ${t.year}';
  }

  void _daftarDonor(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const DonorSuksesPage(),
      ),
      (route) => route.isFirst,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingL,
                  12,
                  AppDimens.paddingL,
                  8,
                ),
                child: Column(
                  children: [
                    HeaderHalaman(
                      judul: 'Donor',
                      leadingIcon: Icons.arrow_back,
                      onTapLeading: () => Navigator.of(context).pop(),
                    ),

                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusM),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Konfirmasi Donor',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 12),

                          _baris(
                            'Nama',
                            'Kaka Muhamad Ridwan',
                          ),
                          _baris(
                            'Email',
                            'kakamr@gmail.com',
                          ),
                          _baris(
                            'Golongan Darah',
                            'O+',
                          ),

                          const SizedBox(height: 12),

                          const Divider(
                            color: AppColors.primary,
                            thickness: .8,
                          ),

                          const SizedBox(height: 12),

                          _baris(
                            'Tanggal Donor',
                            _formatTanggal(tanggalDonor),
                          ),

                          _baris(
                            'Lokasi Donor',
                            lokasiDonor?.nama ?? '-',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius:
                            BorderRadius.circular(AppDimens.radiusM),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kesehatan :',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),

                          const SizedBox(height: 12),

                          ...List.generate(
                            pertanyaan.length,
                            (index) => _itemKesehatan(
                              pertanyaan[index],
                              jawaban[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimens.paddingL,
                0,
                AppDimens.paddingL,
                16,
              ),
              child: ElevatedButton(
                onPressed: () => _daftarDonor(context),
                child: const Text('Daftar Donor'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 105,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12.5,
              ),
            ),
          ),
          const Text(
            ': ',
            style: TextStyle(fontSize: 12.5),
          ),
          Expanded(
            child: Text(
              nilai,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemKesehatan(String pertanyaan, bool jawaban) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            '•  $pertanyaan',
            style: const TextStyle(
              fontSize: 12,
              height: 1.45,
            ),
          ),
        ),

        const SizedBox(width: 12),

        Padding(
          padding: const EdgeInsets.only(right: 10), 
          child: SizedBox(
            width: 65,
            child: Row(
              children: [
                const Text(
                  ': ',
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  jawaban ? 'Ya' : 'Tidak',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}