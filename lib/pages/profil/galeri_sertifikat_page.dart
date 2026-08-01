import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Halaman Galeri Sertifikat (P-003) — sesuai desain Figma.
class GaleriSertifikatPage extends StatelessWidget {
  const GaleriSertifikatPage({super.key});

  void _kembali(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Header: back + judul "Galeri Sertifikat" ----
            Row(
              children: [
                GestureDetector(
                  onTap: () => _kembali(context),
                  child: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Galeri Sertifikat',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 28),
              ],
            ),
            const SizedBox(height: 16),

            // ---- Kartu sertifikat utama ----
            const Center(child: _KartuSertifikatUtama()),
            const SizedBox(height: 24),

            // ---- Section: Riwayat Sertifikat ----
            const Text(
              'Riwayat Sertifikat',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            // ---- Grid galeri sertifikat ----
            const _GaleriSertifikat(),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _DataSertifikat {
  final String judul;
  final String tanggal;
  final String jumlahDarah;

  const _DataSertifikat({
    required this.judul,
    required this.tanggal,
    required this.jumlahDarah,
  });
}

class _DataGaleri {
  final String label;

  const _DataGaleri({required this.label});
}

// ---------------------------------------------------------------------------
// Kartu sertifikat utama
// ---------------------------------------------------------------------------

class _KartuSertifikatUtama extends StatelessWidget {
  const _KartuSertifikatUtama();

  static const _data = _DataSertifikat(
    judul: 'Donor Darah Sukarela - PMI BOGOR',
    tanggal: '10 Desember 2025',
    jumlahDarah: '450ml',
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview sertifikat (224×125, centered)
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 224,
                  height: 125,
                  color: const Color(0xFFFFD8D8),
                  child: const Icon(
                    Icons.description_outlined,
                    size: 56,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Judul sertifikat
            Text(
              _data.judul,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),

            // Meta: tanggal • jumlah darah (centered)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _data.tanggal,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '●',
                    style: TextStyle(
                      fontSize: 10,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _data.jumlahDarah,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Garis pemisah
            const Divider(height: 1, color: AppColors.textPrimary),
            const SizedBox(height: 10),

            // Tombol Unduh PDF & Bagikan (140px each, 15px gap)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TombolAksi(
                  label: 'Unduh PDF',
                  icon: Icons.download_outlined,
                  warnaBackground: AppColors.primary,
                  warnaTeks: Colors.white,
                  warnaIcon: Colors.white,
                  onTap: () {},
                ),
                _TombolAksi(
                  label: 'Bagikan',
                  icon: Icons.share_outlined,
                  warnaBackground: AppColors.surface,
                  warnaTeks: AppColors.primary,
                  warnaIcon: AppColors.primary,
                  onTap: () {},
                  border: Border.all(color: AppColors.border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TombolAksi extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color warnaBackground;
  final Color warnaTeks;
  final Color warnaIcon;
  final VoidCallback onTap;
  final Border? border;

  const _TombolAksi({
    required this.label,
    required this.icon,
    required this.warnaBackground,
    required this.warnaTeks,
    required this.warnaIcon,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        height: 36,
        decoration: BoxDecoration(
          color: warnaBackground,
          borderRadius: BorderRadius.circular(10),
          border: border,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: Offset.zero,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: warnaIcon),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: warnaTeks,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Grid galeri sertifikat (2 kolom)
// ---------------------------------------------------------------------------

class _GaleriSertifikat extends StatelessWidget {
  const _GaleriSertifikat();

  static const _items = [
    _DataGaleri(label: 'Donor #8 - 10 Desember 2025'),
    _DataGaleri(label: 'Donor #7 - 5 Agustus 2025'),
    _DataGaleri(label: 'Donor #6 - 20 Mei 2025'),
    _DataGaleri(label: 'Donor #5 - 10 Maret 2025'),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 24,
        childAspectRatio: 0.72,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        return _ItemGaleri(item: _items[index]);
      },
    );
  }
}

class _ItemGaleri extends StatelessWidget {
  final _DataGaleri item;

  const _ItemGaleri({required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Thumbnail sertifikat (199×111 ratio)
        Container(
          width: double.infinity,
          height: 111,
          decoration: BoxDecoration(
            color: const Color(0xFFFFD8D8),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: Offset.zero,
              ),
            ],
          ),
          child: const Icon(
            Icons.description_outlined,
            size: 40,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 6),
        // Label
        Text(
          item.label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
