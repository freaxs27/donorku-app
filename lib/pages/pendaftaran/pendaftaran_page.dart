import 'package:flutter/material.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import 'jadwal_lokasi_page.dart';

/// Halaman Pendaftaran / Daftar - Step 1 (D-001).
/// Aturan & Tips Donor, dengan tombol lampu di kanan atas yang membuka
/// modal Edukasi & Manfaat Donor (DE-001).
class PendaftaranPage extends StatelessWidget {
  const PendaftaranPage({super.key});

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
    final s = AppStrings.of(context);
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 12, AppDimens.paddingL, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderHalaman(
                    judul: s.donorRulesTitle,
                    trailing: GestureDetector(
                      onTap: () => _bukaEdukasi(context),
                      child: Image.asset('assets/icons/edukasi/lamp.png', width: 24, height: 24),
                    ),
                  ),
                  const SizedBox(height: 14),

                  _KartuAturan(
                    judul: s.rulesBeforeDonation,
                    items: [
                      _ItemAturan(s.ruleAge, [s.ruleAgeDetail]),
                      _ItemAturan(s.ruleWeight, [s.ruleWeightDetail]),
                      _ItemAturan(s.rulePhysical, [
                        s.rulePhysicalDetail1,
                        s.rulePhysicalDetail2,
                      ]),
                      _ItemAturan(s.ruleBloodPressure, [
                        s.ruleBpSystolic,
                        s.ruleBpDiastolic,
                      ]),
                      _ItemAturan(s.ruleHemoglobin, [
                        s.ruleHbMale,
                        s.ruleHbFemale,
                      ]),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _KartuAturan(
                    judul: s.tipsBeforeDonation,
                    items: [
                      _ItemAturan(s.tipSleep, [
                        s.tipSleepDetail1,
                        s.tipSleepDetail2,
                      ]),
                      _ItemAturan(s.tipEat, [
                        s.tipEatDetail1,
                        s.tipEatDetail2,
                        s.tipEatDetail3,
                      ]),
                      _ItemAturan(s.tipHydration, [
                        s.tipHydrationDetail1,
                        s.tipHydrationDetail2,
                      ]),
                      _ItemAturan(s.tipSmoking, [
                        s.tipSmokingDetail1,
                        s.tipSmokingDetail2,
                      ]),
                      _ItemAturan(s.tipHealthy, [s.tipHealthyDetail]),
                    ],
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
              child: Text(s.donateNowButton),
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
    final s = AppStrings.of(context);
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
                  Expanded(
                    child: Text(s.educationModalTitle, style: AppTextStyles.subheading),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(Icons.close, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _KartuEdukasi(
                judul: s.educationSectionTitle,
                items: [
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/shield.png',
                    judul: s.eduSafeTitle,
                    deskripsi: s.eduSafeDesc,
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/syarat.png',
                    judul: s.eduHealthTitle,
                    deskripsi: s.eduHealthDesc,
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/rutin.png',
                    judul: s.eduRoutineTitle,
                    deskripsi: s.eduRoutineDesc,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _KartuEdukasi(
                judul: s.benefitsSectionTitle,
                items: [
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/jantung.png',
                    judul: s.benefitHeartTitle,
                    deskripsi: s.benefitHeartDesc,
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/deteksi.png',
                    judul: s.benefitDetectionTitle,
                    deskripsi: s.benefitDetectionDesc,
                  ),
                  _ItemEdukasi(
                    iconAsset: 'assets/icons/edukasi/produksi.png',
                    judul: s.benefitProductionTitle,
                    deskripsi: s.benefitProductionDesc,
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