import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/core/api_client.dart';
import '../../services/core/api_exception.dart';
import '../../services/auth/session_service.dart';
import '../../core/locale/app_bahasa.dart';
import '../../core/locale/app_strings.dart';
import '../../core/theme/app_tema.dart';
import '../auth/login_page.dart';
import 'pilih_bahasa_page.dart';
import 'sesuaikan_tema_page.dart';
import '../../widgets/theme_sync.dart';

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
      AppPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  void _bukaPilihBahasa() {
    Navigator.of(context).push(
      AppPageRoute(builder: (context) => const PilihBahasaPage()),
    );
  }

  void _bukaSesuaikanTema() {
    Navigator.of(context).push(
      AppPageRoute(builder: (context) => const SesuaikanTemaPage()),
    );
  }

  Future<void> _hapusAkun() async {
    // Popup 1: Konfirmasi hapus akun (Frame 3)
    final konfirmasi = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: AppColors.of(context).background,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ikon warning
              Icon(Icons.warning_amber_rounded,
                  size: 72, color: AppColors.of(context).textPrimary),
              const SizedBox(height: 16),
              Text(
                'Hapus Akun?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.of(context).textPrimary),
              ),
              const SizedBox(height: 10),
              Text(
                'Akun anda akan dihapus secara permanen. '
                'Anda tidak dapat membatalkan tindakan ini',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.of(context).textSecondary),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.of(context).textPrimary,
                        side: BorderSide(color: AppColors.of(context).border),
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Batal',
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: const Text('Hapus Akun',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    if (konfirmasi != true || !mounted) return;

    // Input password via dialog kecil
    final passCtrl = TextEditingController();
    bool lihat = false;
    final password = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateDialog) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.of(context).background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Konfirmasi Password',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                    'Masukkan password Anda untuk melanjutkan:',
                    style:
                        TextStyle(fontSize: 13, color: AppColors.of(context).textSecondary)),
                const SizedBox(height: 12),
                TextField(
                  controller: passCtrl,
                  obscureText: !lihat,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    suffixIcon: GestureDetector(
                      onTap: () =>
                          setStateDialog(() => lihat = !lihat),
                      child: Icon(lihat
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(null),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.of(context).textPrimary,
                          side: BorderSide(color: AppColors.of(context).border),
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.of(context).pop(passCtrl.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(44),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text('Konfirmasi',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    if (password == null || password.isEmpty || !mounted) return;

    // Kirim ke API
    try {
      await ApiClient.deleteWithBody('/account', {'password': password});
      await SessionService.hapusSesi();
      if (!mounted) return;

      // Popup 2: Sukses (Frame 4)
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: AppColors.of(context).background,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ikon centang merah dalam lingkaran
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2.5),
                  ),
                  child: const Icon(Icons.check,
                      size: 36, color: AppColors.primary),
                ),
                const SizedBox(height: 16),
                Text(
                  'Akun Berhasil Dihapus',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.of(context).textPrimary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Anda telah berhasil menghapus akun. '
                  'Terima kasih telah menggunakan aplikasi ini.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13, color: AppColors.of(context).textSecondary),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('Keluar',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Setelah popup sukses ditutup, redirect ke Login
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        AppPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Gagal menghapus akun, coba lagi.')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        LocaleController.instance,
        ThemeController.instance,
      ]),
      builder: (context, _) {
        final s = AppStrings.of(context);
        final namaBahasa = LocaleController.instance.bahasa.namaTampil;
        final namaTema = s.labelTema(ThemeController.instance.tema);

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
                      child: Icon(
                        Icons.arrow_back,
                        size: 28,
                        color: AppColors.of(context).textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        s.pengaturan,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.of(context).textPrimary,
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
                  nilaiTema: namaTema,
                  onPilihBahasa: _bukaPilihBahasa,
                  onSesuaikanTema: _bukaSesuaikanTema,
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
                  onHapusAkun: _hapusAkun,
                  labelKeluar: s.keluar,
                  labelHapusAkun: s.hapusAkun,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Dekorasi kartu
// ---------------------------------------------------------------------------

BoxDecoration _dekorasiKartu(BuildContext context) => BoxDecoration(
      color: AppColors.of(context).surface,
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
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.of(context).textPrimary,
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
      decoration: _dekorasiKartu(context),
      child: Column(
        children: [
          _BarisSwitch(
            icon: Icons.notifications_outlined,
            label: labelNotif,
            value: notifAktif,
            onChanged: onNotifAktif,
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
          _BarisSwitch(
            icon: Icons.mail_outline,
            label: labelEmail,
            value: notifEmail,
            onChanged: onNotifEmail,
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
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
          Icon(icon, size: 24, color: AppColors.of(context).textPrimary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: AppColors.of(context).textPrimary,
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
  final String nilaiTema;
  final VoidCallback onPilihBahasa;
  final VoidCallback onSesuaikanTema;

  const _KartuAplikasi({
    required this.labelBahasa,
    required this.labelTema,
    required this.labelPrivasi,
    required this.nilaiBahasa,
    required this.nilaiTema,
    required this.onPilihBahasa,
    required this.onSesuaikanTema,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu(context),
      child: Column(
        children: [
          _BarisMenu(
            icon: Icons.language,
            label: labelBahasa,
            trailingText: nilaiBahasa,
            onTap: onPilihBahasa,
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
          _BarisMenu(
            icon: Icons.dark_mode_outlined,
            label: labelTema,
            trailingText: nilaiTema,
            onTap: onSesuaikanTema,
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
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
      decoration: _dekorasiKartu(context),
      child: Column(
        children: [
          _BarisMenu(
            icon: Icons.info_outline,
            label: labelTentang,
            onTap: () {},
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
          _BarisMenu(
            icon: Icons.help_outline,
            label: labelBantuan,
            onTap: () {},
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
          _BarisMenu(
            icon: Icons.description_outlined,
            label: labelSyarat,
            onTap: () {},
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
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
            Icon(icon, size: 24, color: AppColors.of(context).textPrimary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.of(context).textPrimary,
                ),
              ),
            ),
            if (trailingText != null) ...[
              Text(
                trailingText!,
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.of(context).textSecondary,
                ),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.chevron_right,
              size: 24,
              color: AppColors.of(context).textSecondary,
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
  final VoidCallback onHapusAkun;
  final String labelKeluar;
  final String labelHapusAkun;

  const _KartuAkun({
    required this.onKeluar,
    required this.onHapusAkun,
    required this.labelKeluar,
    required this.labelHapusAkun,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _dekorasiKartu(context),
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
                  Icon(Icons.logout, size: 24, color: AppColors.of(context).textPrimary),
                  const SizedBox(width: 8),
                  Text(
                    labelKeluar,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, color: AppColors.of(context).border, indent: 56),
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
