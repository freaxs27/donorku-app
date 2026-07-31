import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';

// (D-003).
class KuisionerKesehatanPage extends StatefulWidget {
  const KuisionerKesehatanPage({super.key});

  @override
  State<KuisionerKesehatanPage> createState() => _KuisionerKesehatanPageState();
}

class _KuisionerKesehatanPageState extends State<KuisionerKesehatanPage> {
  static const List<String> _pertanyaan = [
    'Apakah Anda sedang demam, flu, batuk, atau sakit?',
    'Apakah Anda merasa sehat hari ini?',
    'Apakah pernah dirawat di rumah sakit',
    'Apakah Anda sudah makan dalam 3-4 jam terakhir?',
    'Apakah Anda mengonsumsi alkohol dalam 24 jam terakhir?',
    'Apakah Anda sedang mengonsumsi obat-obatan tertentu?',
    'Apakah Anda pernah pingsan atau pusing saat donor darah sebelumnya?',
    'Apakah Anda memiliki riwayat penyakit jantung, tekanan darah, atau diabetes?',
    'Apakah Anda pernah didiagnosis hepatitis, HIV/AIDS, atau penyakit menular darah?',
    'Apakah Anda sedang hamil atau menyusui? (untuk wanita)',
    'Apakah Anda baru menjalani operasi, atau tindakan medis dalam 6 bulan terakhir?',
    'Apakah Anda baru menerima vaksinasi dalam 1 bulan terakhir?',
    'Apakah Anda bersedia mendonorkan darah secara sukarela tanpa paksaan?',
  ];

  late final List<bool> _jawaban = List.filled(_pertanyaan.length, true);

  void _selanjutnya() {
    debugPrint('Jawaban kuisioner: $_jawaban');
  }

  @override
  Widget build(BuildContext context) {
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
                      judul: 'Kuesioner Kesehatan',
                      leadingIcon: Icons.arrow_back,
                      onTapLeading: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Silahkan untuk menjawab beberapa pertanyaan di bawah sebelum lanjut',
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),

                    for (int i = 0; i < _pertanyaan.length; i++) ...[
                      _KartuPertanyaan(
                        pertanyaan: _pertanyaan[i],
                        jawabanYa: _jawaban[i],
                        onUbah: (ya) => setState(() => _jawaban[i] = ya),
                      ),
                      if (i != _pertanyaan.length - 1) const SizedBox(height: 10),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 0, AppDimens.paddingL, 16),
              child: ElevatedButton(
                onPressed: _selanjutnya,
                child: const Text('Selanjutnya'),
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(pertanyaan, style: const TextStyle(fontSize: 12.5)),
          ),
          const SizedBox(width: 8),
          _pilihanRadio(label: 'Ya', terpilih: jawabanYa, onTap: () => onUbah(true)),
          const SizedBox(width: 10),
          _pilihanRadio(label: 'Tidak', terpilih: !jawabanYa, onTap: () => onUbah(false)),
        ],
      ),
    );
  }

  Widget _pilihanRadio({required String label, required bool terpilih, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            terpilih ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18,
            color: terpilih ? AppColors.primary : AppColors.textHint,
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}