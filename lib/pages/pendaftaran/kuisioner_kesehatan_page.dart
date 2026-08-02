import 'package:flutter/material.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../model/jadwal_ringkas.dart';
import 'donor_konfirmasi_page.dart';
import '../../widgets/theme_sync.dart';

// (D-003).
class KuisionerKesehatanPage extends StatefulWidget {
  final JadwalRingkas jadwalTerpilih;

  const KuisionerKesehatanPage({super.key, required this.jadwalTerpilih});

  @override
  State<KuisionerKesehatanPage> createState() => _KuisionerKesehatanPageState();
}

class _KuisionerKesehatanPageState extends State<KuisionerKesehatanPage> {
  /// Urutan key ini WAJIB sama persis urutannya dengan [questionnaireQuestions]
  /// dari AppStrings, dan HARUS sama persis dengan nama kolom di
  /// `KuesionerKesehatan` (schema.prisma) / body yang dibaca backend
  /// (`route.ts` pendaftaran: `...jawaban` di-spread langsung ke Prisma).
  static const List<String> _keyKuisioner = [
    'demam_flu_batuk',
    'sehat_hari_ini',
    'pernah_dirawat',
    'sudah_makan',
    'konsumsi_alkohol',
    'konsumsi_obat',
    'pernah_pingsan_donor',
    'riwayat_jantung_diabetes',
    'riwayat_hepatitis_hiv',
    'hamil_menyusui',
    'baru_operasi',
    'baru_vaksin',
    'bersedia_sukarela',
  ];

  late List<bool> _jawaban;

  @override
  void initState() {
    super.initState();
    _jawaban = List.filled(_keyKuisioner.length, true);
  }

  void _selanjutnya() {
    final pertanyaan = AppStrings.of(context).questionnaireQuestions;
    final jawabanMap = <String, bool>{
      for (int i = 0; i < _keyKuisioner.length; i++) _keyKuisioner[i]: _jawaban[i],
    };

    Navigator.of(context).push(
      AppPageRoute(
        builder: (context) => DonorKonfirmasiPage(
          jadwalTerpilih: widget.jadwalTerpilih,
          pertanyaan: pertanyaan,
          jawaban: _jawaban,
          jawabanMap: jawabanMap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final pertanyaanKuisioner = s.questionnaireQuestions;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 12, AppDimens.paddingL, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    HeaderHalaman(
                      judul: s.healthQuestionnaireTitle,
                      leadingIcon: Icons.arrow_back,
                      onTapLeading: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.questionnaireIntro,
                      style: AppTextStyles.body(context).copyWith(color: AppColors.of(context).textSecondary),
                    ),
                    const SizedBox(height: 16),

                    for (int i = 0; i < pertanyaanKuisioner.length; i++) ...[
                      _KartuPertanyaan(
                        pertanyaan: pertanyaanKuisioner[i],
                        jawabanYa: _jawaban[i],
                        onUbah: (ya) => setState(() => _jawaban[i] = ya),
                      ),
                      if (i != pertanyaanKuisioner.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 0, AppDimens.paddingL, 16),
              child: ElevatedButton(
                onPressed: _selanjutnya,
                child: Text(s.nextButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KartuPertanyaan extends StatelessWidget {
  final String pertanyaan;
  final bool jawabanYa;
  final ValueChanged<bool> onUbah;

  const _KartuPertanyaan({
    required this.pertanyaan,
    required this.jawabanYa,
    required this.onUbah,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.of(context).surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(pertanyaan, style: const TextStyle(fontSize: 12.5)),
          ),
          const SizedBox(width: 8),
          _pilihanRadio(context, label: s.yesLabel, terpilih: jawabanYa, onTap: () => onUbah(true)),
          const SizedBox(width: 10),
          _pilihanRadio(context, label: s.noLabel, terpilih: !jawabanYa, onTap: () => onUbah(false)),
        ],
      ),
    );
  }

  Widget _pilihanRadio(
    BuildContext context, {
    required String label,
    required bool terpilih,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            terpilih ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
            color: terpilih ? AppColors.primary : AppColors.of(context).textHint,
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
