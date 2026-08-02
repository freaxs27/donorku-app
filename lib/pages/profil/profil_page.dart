import 'package:flutter/material.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../model/data_profil.dart';
import '../../services/profil/profil_service.dart';
import '../../services/core/api_exception.dart';
import 'galeri_sertifikat_page.dart';
import 'pengaturan_page.dart';
import 'edit_profil_page.dart';
import 'edit_password_page.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final ProfilService _service = ProfilService();

  DataProfil? _data;
  bool _sedangMemuat = false;
  String? _pesanError;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    setState(() { _sedangMemuat = true; _pesanError = null; });
    try {
      final hasil = await _service.ambilProfil();
      setState(() => _data = hasil);
    } on ApiException catch (e) {
      setState(() => _pesanError = e.message);
    } catch (_) {
      setState(() => _pesanError = AppStrings.of(context).loadProfileFailed);
    } finally {
      if (mounted) setState(() => _sedangMemuat = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return SafeArea(
      child: _sedangMemuat
          ? const Center(child: CircularProgressIndicator())
          : _pesanError != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_pesanError!, style: AppTextStyles.caption,
                          textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      TextButton(onPressed: _muatData, child: Text(s.tryAgain)),
                    ],
                  ),
                )
              : _buildKonten(s),
    );
  }

  Widget _buildKonten(AppStrings s) {
    final data = _data;
    if (data == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: _muatData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                const SizedBox(width: 28),
                Expanded(
                  child: Text(s.profileTitle,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.subheading.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: 28,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const PengaturanPage()),
                    ),
                    child: const Icon(Icons.settings_outlined,
                        size: 26, color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Foto profil
            Center(child: _FotoProfil(fotoUrl: data.fotoProfil)),
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
                        blurRadius: 4, offset: Offset.zero,
                      ),
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
                            Text('${data.totalDonasi}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold,
                                    color: AppColors.primary)),
                            const SizedBox(height: 2),
                            Text(s.totalDonations,
                                style: const TextStyle(fontSize: 10,
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
                            Text('${data.totalMlDarah}',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold,
                                    color: AppColors.primary)),
                            const SizedBox(height: 2),
                            Text(s.mlBlood,
                                style: const TextStyle(fontSize: 10,
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

            // Informasi Pribadi
            _JudulSection(text: s.personalInfoSection),
            const SizedBox(height: 8),
            _KartuInfoPribadi(data: data, s: s),
            const SizedBox(height: 12),

            // Tombol Edit Profil + Edit Password
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => EditProfilPage(data: data)),
                      );
                      // Refresh setelah kembali dari edit
                      _muatData();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.border),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(s.editProfileButton,
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const EditPasswordPage()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: Text(s.editPasswordButton,
                        style: const TextStyle(fontSize: 14)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Lainnya
            _JudulSection(text: s.otherSection),
            const SizedBox(height: 8),
            Text(s.donorCertification,
                style: const TextStyle(fontSize: 16, color: AppColors.textPrimary)),
            const SizedBox(height: 8),
            _KartuSertifikasi(openGalleryLabel: s.openGalleryButton),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

class _FotoProfil extends StatelessWidget {
  final String? fotoUrl;
  const _FotoProfil({this.fotoUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120, height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFFFFD8D8),
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: fotoUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.network(fotoUrl!, fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const Icon(Icons.person,
                      size: 56, color: AppColors.primary)),
            )
          : const Icon(Icons.person, size: 56, color: AppColors.primary),
    );
  }
}

class _JudulSection extends StatelessWidget {
  final String text;
  const _JudulSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
            color: AppColors.textPrimary));
  }
}

class _KartuInfoPribadi extends StatelessWidget {
  final DataProfil data;
  final AppStrings s;
  const _KartuInfoPribadi({required this.data, required this.s});

  @override
  Widget build(BuildContext context) {
    final baris = [
      (s.fullNameLabel, data.namaLengkap),
      (s.phoneProfilLabel, data.noHp ?? '-'),
      (s.dobLabel, data.tanggalLahirFormat),
      (s.addressLabel, data.alamat ?? '-'),
      (s.emailLabel, data.email),
      (s.bloodTypeLabel, data.golonganDarah),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4, offset: Offset.zero),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < baris.length; i++) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2,
                    child: Text(baris[i].$1,
                        style: const TextStyle(fontSize: 14,
                            color: AppColors.textPrimary))),
                Expanded(flex: 3,
                    child: Text(': ${baris[i].$2}',
                        style: const TextStyle(fontSize: 14,
                            color: AppColors.textPrimary))),
              ],
            ),
            if (i != baris.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 6),
                child: Divider(height: 1, color: AppColors.border),
              ),
          ],
        ],
      ),
    );
  }
}

class _KartuSertifikasi extends StatelessWidget {
  final String openGalleryLabel;
  const _KartuSertifikasi({required this.openGalleryLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4, offset: Offset.zero),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt_outlined, size: 32,
              color: AppColors.textPrimary),
          const SizedBox(height: 12),
          SizedBox(
            width: 112, height: 32,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const GaleriSertifikatPage()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(openGalleryLabel, style: const TextStyle(fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}