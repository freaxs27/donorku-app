import 'package:flutter/material.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../model/jadwal_ringkas.dart';
import '../../services/pendaftaran/pendaftaran_service.dart';
import '../../services/profil/profil_service.dart';
import '../../services/core/api_exception.dart';
import '../../services/auth/session_service.dart';
import 'donor_sukses_page.dart';
import '../../widgets/theme_sync.dart';

/// Halaman Donor - Konfirmasi (D-004).
/// Merangkum data dari step sebelumnya: profil (nama/email/golongan darah),
/// jadwal (tanggal, jam, lokasi) dari D-002, dan jawaban kuisioner dari D-003.
///
/// Di sinilah pendaftaran BENERAN dikirim ke backend saat "Daftar Donor"
/// ditekan (POST /pendaftaran, dengan id_jadwal + jawaban kuisioner).
class DonorKonfirmasiPage extends StatefulWidget {
  final JadwalRingkas jadwalTerpilih;
  final List<String> pertanyaan;
  final List<bool> jawaban;
  final Map<String, bool> jawabanMap;

  const DonorKonfirmasiPage({
    super.key,
    required this.jadwalTerpilih,
    required this.pertanyaan,
    required this.jawaban,
    required this.jawabanMap,
  });

  @override
  State<DonorKonfirmasiPage> createState() => _DonorKonfirmasiPageState();
}

class _DonorKonfirmasiPageState extends State<DonorKonfirmasiPage> {
  final PendaftaranService _pendaftaranService = PendaftaranService();
  final ProfilService _profilService = ProfilService();

  String _nama = '-';
  String _email = '-';
  String _golonganDarah = '-';
  bool _sedangKirim = false;

  @override
  void initState() {
    super.initState();
    _muatDataSesi();
  }

  Future<void> _muatDataSesi() async {
    final nama = await SessionService.ambilNama();
    final email = await SessionService.ambilEmail();

    String golongan = '-';
    try {
      final profil = await _profilService.ambilProfil();
      golongan = profil.golonganDarah;
    } on ApiException catch (e) {
      if (e.statusCode == 401) return;
      // Fallback ke sesi saja kalau profil gagal dimuat.
    } catch (_) {
      // Biarkan golongan '-' — konfirmasi tetap bisa dilanjutkan.
    }

    if (!mounted) return;
    setState(() {
      _nama = nama ?? '-';
      _email = email ?? '-';
      _golonganDarah = golongan;
    });
  }

  String _formatTanggal(BuildContext context, DateTime t) {
    return AppStrings.of(context).formatTanggal(t);
  }

  Future<void> _daftarDonor() async {
    setState(() => _sedangKirim = true);

    try {
      await _pendaftaranService.daftar(
        idJadwal: widget.jadwalTerpilih.idJadwal,
        jawaban: widget.jawabanMap,
      );

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        AppPageRoute(builder: (context) => const DonorSuksesPage()),
        (route) => route.isFirst,
      );
    } on ApiException catch (e) {
      // 401 sudah diurus ApiClient (clear sesi + redirect Login).
      if (e.statusCode == 401) return;
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan(AppStrings.of(context).unexpectedError);
    } finally {
      if (mounted) setState(() => _sedangKirim = false);
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final jadwal = widget.jadwalTerpilih;

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
                      judul: s.donorTitle,
                      leadingIcon: Icons.arrow_back,
                      onTapLeading: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(height: 16),

                    // Kartu Konfirmasi Donor
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).surface,
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.donationConfirmTitle,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(height: 10),
                          _baris(s.nameLabel, _nama),
                          _baris(s.emailLabel, _email),
                          _baris(s.bloodTypeLabel, _golonganDarah),
                          const SizedBox(height: 10),
                          const Divider(color: AppColors.primary, thickness: 0.8),
                          const SizedBox(height: 10),
                          _baris(s.donationDateLabel, _formatTanggal(context, jadwal.tanggalPelaksanaan)),
                          _baris(s.donationTimeLabel, '${jadwal.jamMulaiFormat} - ${jadwal.jamSelesaiFormat}'),
                          _baris(s.donationLocationLabel, jadwal.lokasi.namaLokasi),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Kartu Kesehatan (rekap kuisioner)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppDimens.paddingM),
                      decoration: BoxDecoration(
                        color: AppColors.of(context).surface,
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.healthSectionTitle,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          const SizedBox(height: 10),
                          for (int i = 0; i < widget.pertanyaan.length; i++)
                            Padding(
                              padding: const EdgeInsets.fromLTRB(4, 0, 4, 8),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      '•  ${widget.pertanyaan[i]}',
                                      style: const TextStyle(fontSize: 11.5),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    ': ${widget.jawaban[i] ? s.yesLabel : s.noLabel}',
                                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 0, AppDimens.paddingL, 16),
              child: ElevatedButton(
                onPressed: _sedangKirim ? null : _daftarDonor,
                child: _sedangKirim
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(s.registerDonorButton),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _baris(String label, String nilai) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 100, child: Text(label, style: const TextStyle(fontSize: 12.5))),
          const Text(': ', style: TextStyle(fontSize: 12.5)),
          Expanded(
            child: Text(nilai, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}