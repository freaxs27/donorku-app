import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../auth/login_page.dart';

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

  void _keluar() {
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
            // ---- Header: back + judul "Pengaturan" ----
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
                const Expanded(
                  child: Text(
                    'Pengaturan',
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
            const SizedBox(height: 32),

            // ---- Section: Notifikasi ----
            const _JudulSection(text: 'Notifikasi'),
            const SizedBox(height: 8),
            _KartuNotifikasi(
              notifAktif: _notifAktif,
              notifEmail: _notifEmail,
              sms: _sms,
              onNotifAktif: (v) => setState(() => _notifAktif = v),
              onNotifEmail: (v) => setState(() => _notifEmail = v),
              onSms: (v) => setState(() => _sms = v),
            ),
            const SizedBox(height: 24),

            // ---- Section: Aplikasi ----
            const _JudulSection(text: 'Aplikasi'),
            const SizedBox(height: 8),
            _KartuAplikasi(),
            const SizedBox(height: 24),

            // ---- Section: Tentang Kami ----
            const _JudulSection(text: 'Tentang Kami'),
            const SizedBox(height: 8),
            _KartuTentangKami(),
            const SizedBox(height: 24),

            // ---- Section: Akun ----
            const _JudulSection(text: 'Akun'),
            const SizedBox(height: 8),
            _KartuAkun(onKeluar: _keluar),
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
  final ValueChanged<bool> onNotifAktif;
  final ValueChanged<bool> onNotifEmail;
  final ValueChanged<bool> onSms;

  const _KartuNotifikasi({
    required this.notifAktif,
    required this.notifEmail,
    required this.sms,
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
            label: 'Nyalakan Notifikasi',
            value: notifAktif,
            onChanged: onNotifAktif,
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisSwitch(
            icon: Icons.mail_outline,
            label: 'Notifikasi Email',
            value: notifEmail,
            onChanged: onNotifEmail,
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisSwitch(
            icon: Icons.comment_outlined,
            label: 'SMS',
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
            activeColor: const Color(0xFF34C759),
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          _BarisMenu(
            icon: Icons.language,
            label: 'Pilih Bahasa',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.dark_mode_outlined,
            label: 'Sesuaikan Tema',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.shield_outlined,
            label: 'Pengaturan Privasi',
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          _BarisMenu(
            icon: Icons.info_outline,
            label: 'Tentang Donor Ku',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.help_outline,
            label: 'Bantuan',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.description_outlined,
            label: 'Syarat & Ketentuan',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.border, indent: 56),
          _BarisMenu(
            icon: Icons.lock_outline,
            label: 'Kebijakan Privasi',
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
  final VoidCallback? onTap;

  const _BarisMenu({
    required this.icon,
    required this.label,
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

  const _KartuAkun({required this.onKeluar});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          // Baris Keluar
          InkWell(
            onTap: onKeluar,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.logout, size: 24, color: AppColors.textPrimary),
                  SizedBox(width: 8),
                  Text(
                    'Keluar',
                    style: TextStyle(
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
          // Tombol Hapus Akun
          InkWell(
            onTap: () {},
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.delete_outline, size: 24, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Hapus Akun',
                    style: TextStyle(
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
