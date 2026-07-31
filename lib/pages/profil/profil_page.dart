import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../widgets/main_layout.dart';
import '../auth/login_page.dart';

/// Halaman Profil (P-001).
class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  static const _dataProfil = _DataProfil(
    nama: 'Kaka Muhamad Ridwan',
    email: 'kakamr@gmail.com',
    golonganDarah: 'O+',
    totalDonor: 8,
    donorTerakhir: '5 Agustus 2025',
    donorKembali: '2 Februari 2026',
  );

  void _keRiwayat(BuildContext context) {
    MainLayoutScope.of(context)?.pindahTab(3);
  }

  void _keluar(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
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
            child: HeaderHalaman(judul: 'Profil'),
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
                  _KartuProfil(data: _dataProfil),
                  const SizedBox(height: 12),
                  _KartuStatistik(data: _dataProfil),
                  const SizedBox(height: 12),
                  _KartuMenu(
                    onRiwayatDonor: () => _keRiwayat(context),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Ubah Profil'),
                  ),
                  const SizedBox(height: 12),
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
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Data
// ---------------------------------------------------------------------------

class _DataProfil {
  final String nama;
  final String email;
  final String golonganDarah;
  final int totalDonor;
  final String donorTerakhir;
  final String donorKembali;

  const _DataProfil({
    required this.nama,
    required this.email,
    required this.golonganDarah,
    required this.totalDonor,
    required this.donorTerakhir,
    required this.donorKembali,
  });
}

class _ItemMenu {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ItemMenu({
    required this.icon,
    required this.label,
    this.onTap,
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

class _KartuProfil extends StatelessWidget {
  final _DataProfil data;

  const _KartuProfil({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: const Color(0xFFFFD8D8),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.nama,
                  style: AppTextStyles.body.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(data.email, style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.12),
                  blurRadius: 4,
                  offset: Offset.zero,
                ),
              ],
            ),
            child: Text(
              data.golonganDarah,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KartuStatistik extends StatelessWidget {
  final _DataProfil data;

  const _KartuStatistik({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          Expanded(
            child: _KolomStat(
              nilai: '${data.totalDonor}',
              label: 'Total Donor',
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _KolomStat(
              nilai: data.donorTerakhir,
              label: 'Donor Terakhir',
              nilaiKecil: true,
            ),
          ),
          Container(width: 1, height: 48, color: AppColors.border),
          Expanded(
            child: _KolomStat(
              nilai: data.donorKembali,
              label: 'Donor Kembali',
              nilaiKecil: true,
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
  final bool nilaiKecil;

  const _KolomStat({
    required this.nilai,
    required this.label,
    this.nilaiKecil = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        children: [
          Text(
            nilai,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: nilaiKecil ? 11 : 28,
              fontWeight: FontWeight.bold,
              color: nilaiKecil ? AppColors.textPrimary : AppColors.primary,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _KartuMenu extends StatelessWidget {
  final VoidCallback onRiwayatDonor;

  const _KartuMenu({required this.onRiwayatDonor});

  @override
  Widget build(BuildContext context) {
    final items = [
      _ItemMenu(
        icon: Icons.person_outline,
        label: 'Informasi Pribadi',
        onTap: () {},
      ),
      _ItemMenu(
        icon: Icons.history,
        label: 'Riwayat Donor',
        onTap: onRiwayatDonor,
      ),
      _ItemMenu(
        icon: Icons.workspace_premium_outlined,
        label: 'Sertifikat',
        onTap: () {},
      ),
      _ItemMenu(
        icon: Icons.lock_outline,
        label: 'Keamanan & Akun',
        onTap: () {},
      ),
    ];

    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _BarisMenu(item: items[i]),
            if (i != items.length - 1)
              const Divider(height: 1, color: AppColors.border, indent: 56),
          ],
        ],
      ),
    );
  }
}

class _BarisMenu extends StatelessWidget {
  final _ItemMenu item;

  const _BarisMenu({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 18, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
