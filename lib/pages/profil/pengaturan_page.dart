import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/core/api_client.dart';
import '../../services/core/api_exception.dart';
import '../../services/auth/session_service.dart';
import '../../core/locale/app_bahasa.dart';
import '../../core/locale/app_strings.dart';
import '../auth/login_page.dart';
import 'pilih_bahasa_page.dart';

/// Halaman Pengaturan (P-002) — sesuai desain Figma.
class PengaturanPage extends StatefulWidget {
  const PengaturanPage({super.key});

  @override
  State<PengaturanPage> createState() => _PengaturanPageState();
}

class _PengaturanPageState extends State<PengaturanPage> {
  bool _notifAktif = true;
  bool _notifEmail = false;
  bool _sms = true;

  void _kembali() {
    Navigator.of(context).pop();
  }

  Future<void> _keluar() async {
    await SessionService.hapusSesi();
    if (!mounted) return;
    // rootNavigator: true -- lihat penjelasan di profil_page.dart
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _bukaPilihBahasa() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const PilihBahasaPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final namaBahasa = LocaleController.instance.bahasa.namaTampil;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _kembali,
                  child: const Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: Text(
                    s.pengaturan,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 28),
              ],
            ),
            const SizedBox(height: 32),

            _JudulSection(text: s.notifikasi),
            const SizedBox(height: 8),
            _KartuNotifikasi(
              notifAktif: _notifAktif,
              notifEmail: _notifEmail,
              sms: _sms,
              labelNotif: s.nyalakanNotifikasi,
              labelEmail: s.notifikasiEmail,
              labelSms: s.sms,
              onNotifAktif: (v) => setState(() => _notifAktif = v),
              onNotifEmail: (v) => setState(() => _notifEmail = v),
              onSms: (v) => setState(() => _sms = v),
            ),
            const SizedBox(height: 24),

            _JudulSection(text: s.aplikasi),
            const SizedBox(height: 8),
            _KartuAplikasi(
              labelBahasa: s.pilihBahasa,
              labelTema: s.sesuaikanTema,
              labelPrivasi: s.pengaturanPrivasi,
              nilaiBahasa: namaBahasa,
              onPilihBahasa: _bukaPilihBahasa,
            ),
            const SizedBox(height: 24),

            _JudulSection(text: s.tentangKami),
            const SizedBox(height: 8),
            _KartuTentangKami(
              labelTentang: s.tentangDonorKu,
              labelBantuan: s.bantuan,
              labelSyarat: s.syaratKetentuan,
              labelPrivasi: s.kebijakanPrivasi,
            ),
            const SizedBox(height: 24),

            _JudulSection(text: s.akun),
            const SizedBox(height: 8),
            _KartuAkun(
              onKeluar: _keluar,
              labelKeluar: s.keluar,
              labelHapusAkun: s.hapusAkun,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dekorasi kartu
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

// ---------------------------------------------------------------------------
// Judul section
// ---------------------------------------------------------------------------

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

// ---------------------------------------------------------------------------
// Kartu Notifikasi (3 baris dengan switch)
// ---------------------------------------------------------------------------

class _KartuNotifikasi extends StatelessWidget {
  final bool notifAktif;
  final bool notifEmail;
  final bool sms;
  final String labelNotif;
  final String labelEmail;
  final String labelSms;
  final ValueChanged<bool> onNotifAktif;
  final ValueChanged<bool> onNotifEmail;
  final ValueChanged<bool> onSms;

  const _KartuNotifikasi({
    required this.notifAktif,
    required this.notifEmail,
    required this.sms,
    required this.labelNotif,
    required this.labelEmail,
    required this.labelSms,
    required this.onNotifAktif,
    required this.onNotifEmail,
    required this.onSms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          _BarisSwitch(
            icon: Icons.notifications_outlined,
            label: labelNotif,
            value: notifAktif,
            onChanged: onNotifAktif,
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisSwitch(
            icon: Icons.mail_outline,
            label: labelEmail,
            value: notifEmail,
            onChanged: onNotifEmail,
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisSwitch(
            icon: Icons.comment_outlined,
            label: labelSms,
            value: sms,
            onChanged: onSms,
          ),
        ],
      ),
    );
  }
}

class _BarisSwitch extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BarisSwitch({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppColors.textPrimary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF34C759),
            activeTrackColor: const Color(0xFF34C759).withValues(alpha: 0.5),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFFE6E0EC),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kartu Aplikasi (3 baris dengan chevron)
// ---------------------------------------------------------------------------

class _KartuAplikasi extends StatelessWidget {
  final String labelBahasa;
  final String labelTema;
  final String labelPrivasi;
  final String nilaiBahasa;
  final VoidCallback onPilihBahasa;

  const _KartuAplikasi({
    required this.labelBahasa,
    required this.labelTema,
    required this.labelPrivasi,
    required this.nilaiBahasa,
    required this.onPilihBahasa,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          _BarisMenu(
            icon: Icons.language,
            label: labelBahasa,
            trailingText: nilaiBahasa,
            onTap: onPilihBahasa,
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.dark_mode_outlined,
            label: labelTema,
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.shield_outlined,
            label: labelPrivasi,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kartu Tentang Kami (4 baris dengan chevron)
// ---------------------------------------------------------------------------

class _KartuTentangKami extends StatelessWidget {
  final String labelTentang;
  final String labelBantuan;
  final String labelSyarat;
  final String labelPrivasi;

  const _KartuTentangKami({
    required this.labelTentang,
    required this.labelBantuan,
    required this.labelSyarat,
    required this.labelPrivasi,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          _BarisMenu(
            icon: Icons.info_outline,
            label: labelTentang,
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.help_outline,
            label: labelBantuan,
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.description_outlined,
            label: labelSyarat,
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.lock_outline,
            label: labelPrivasi,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Baris menu dengan ikon + label + chevron
// ---------------------------------------------------------------------------

class _BarisMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? trailingText;
  final VoidCallback? onTap;

  const _BarisMenu({
    required this.icon,
    required this.label,
    this.trailingText,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.textPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kartu Akun (Keluar + Hapus Akun)
// ---------------------------------------------------------------------------

class _KartuAkun extends StatelessWidget {
  final VoidCallback onKeluar;
  final String labelKeluar;
  final String labelHapusAkun;

  const _KartuAkun({
    required this.onKeluar,
    required this.labelKeluar,
    required this.labelHapusAkun,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          InkWell(
            onTap: onKeluar,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.logout, size: 24, color: AppColors.textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    labelKeluar,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          InkWell(
            onTap: onHapusAkun,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  const Icon(Icons.delete_outline, size: 24, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    labelHapusAkun,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.primary,
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
