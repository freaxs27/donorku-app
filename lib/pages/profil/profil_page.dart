import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../auth/login_page.dart';
import 'pengaturan_page.dart';

/// Halaman Profil (P-001) — sesuai desain Figma.
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  static const _dataProfil = _DataProfil(
    nama: 'Kaka Muhamad Ridwan',
    noTelepon: '081253041346',
    tanggalLahir: '28 - 6 - 2006',
    alamat: 'Wado, Sumedang',
    email: 'kakamr@gmail.com',
    golonganDarah: 'O+',
    totalDonasi: 8,
    totalMlDarah: 829,
  );

  void _keluar(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---- Header: judul "Profil" + ikon settings ----
            Row(
              children: [
                const SizedBox(width: 28),
                Expanded(
                  child: Text(
                    'Profil',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.subheading.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 28,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PengaturanPage(),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.settings_outlined,
                      size: 26,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ---- Foto profil ----
            Center(child: _FotoProfil()),
            const SizedBox(height: 28),

            // ---- Kartu statistik (Total Donasi / ml Darah) ----
            _KartuStatistik(data: _dataProfil),
            const SizedBox(height: 24),

            // ---- Section: Informasi Pribadi ----
            const _JudulSection(text: 'Informasi Pribadi'),
            const SizedBox(height: 8),
            _KartuInfoPribadi(data: _dataProfil),
            const SizedBox(height: 24),

            // ---- Section: Lainnya ----
            const _JudulSection(text: 'Lainnya'),
            const SizedBox(height: 8),

            // ---- Section: Sertifikasi Pendonor ----
            const Text(
              'Sertifikasi Pendonor',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            _KartuSertifikasi(),
            const SizedBox(height: 24),

            // ---- Tombol keluar ----
            TextButton(
              onPressed: () => _keluar(context),
              child: const Text(
                'Keluar',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _DataProfil {
  final String nama;
  final String noTelepon;
  final String tanggalLahir;
  final String alamat;
  final String email;
  final String golonganDarah;
  final int totalDonasi;
  final int totalMlDarah;

  const _DataProfil({
    required this.nama,
    required this.noTelepon,
    required this.tanggalLahir,
    required this.alamat,
    required this.email,
    required this.golonganDarah,
    required this.totalDonasi,
    required this.totalMlDarah,
  });
}

// ---------------------------------------------------------------------------
// Widgets
// ---------------------------------------------------------------------------

BoxDecoration get _dekorasiKartu => BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.25),
          blurRadius: 4,
          offset: Offset.zero,
        ),
      ],
    );

/// Foto profil bulat dengan border putih & drop shadow (159×159 di Figma).
class _FotoProfil extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 159,
      height: 159,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFFD8D8),
        border: Border.all(color: Colors.white, width: 4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      child: const Icon(
        Icons.person,
        size: 64,
        color: AppColors.primary,
      ),
    );
  }
}

/// Judul section (Poppins Bold 16 di Figma).
class _JudulSection extends StatelessWidget {
  final String text;

  const _JudulSection({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }
}

/// Kartu statistik: "Total Donasi" | "ml Darah" dipisah garis vertikal.
class _KartuStatistik extends StatelessWidget {
  final _DataProfil data;

  const _KartuStatistik({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _KolomStat(
              nilai: '${data.totalDonasi}',
              label: 'Total Donasi',
            ),
          ),
          Container(width: 1, height: 34, color: AppColors.border),
          Expanded(
            child: _KolomStat(
              nilai: '${data.totalMlDarah}',
              label: 'ml Darah',
            ),
          ),
        ],
      ),
    );
  }
}

class _KolomStat extends StatelessWidget {
  final String nilai;
  final String label;

  const _KolomStat({required this.nilai, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          nilai,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

/// Kartu Informasi Pribadi: label di kiri, nilai di kanan.
class _KartuInfoPribadi extends StatelessWidget {
  final _DataProfil data;

  const _KartuInfoPribadi({required this.data});

  @override
  Widget build(BuildContext context) {
    final baris = [
      ('Nama Lengkap', data.nama),
      ('No Telepon', data.noTelepon),
      ('Tanggal Lahir', data.tanggalLahir),
      ('Alamat', data.alamat),
      ('Email', data.email),
      ('Golongan Darah', data.golonganDarah),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          for (int i = 0; i < baris.length; i++) ...[
            _BarisInfo(label: baris[i].$1, nilai: baris[i].$2),
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

class _BarisInfo extends StatelessWidget {
  final String label;
  final String nilai;

  const _BarisInfo({required this.label, required this.nilai});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            ': $nilai',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ],
    );
  }
}

/// Kartu Sertifikasi Pendonor: ikon kamera + tombol "Buka Galeri".
class _KartuSertifikasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 182,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: _dekorasiKartu,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              size: 28,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 112,
            height: 27,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Buka Galeri',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
