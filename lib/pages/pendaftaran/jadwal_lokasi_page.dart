import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../model/jadwal_ringkas.dart';
import '../../services/jadwal/jadwal_service.dart';
import '../../services/core/api_exception.dart';
import 'kuisioner_kesehatan_page.dart';

// (D-002).
class JadwalLokasiPage extends StatefulWidget {
  const JadwalLokasiPage({super.key});

  @override
  State<JadwalLokasiPage> createState() => _JadwalLokasiPageState();
}

class _JadwalLokasiPageState extends State<JadwalLokasiPage> {
  DateTime _bulanDitampilkan = DateTime(DateTime.now().year, DateTime.now().month);
  DateTime? _tanggalDipilih = DateTime.now();
  JadwalRingkas? _jadwalDipilih;

  final JadwalService _jadwalService = JadwalService();
  List<JadwalRingkas> _daftarJadwal = [];
  bool _sedangMemuat = false;
  String? _pesanError;

  static const List<String> _namaBulan = [
    'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
    'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
  ];
  static const List<String> _namaHari = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void initState() {
    super.initState();
    _muatJadwal();
  }

  Future<void> _muatJadwal() async {
    if (_tanggalDipilih == null) return;

    setState(() {
      _sedangMemuat = true;
      _pesanError = null;
      _jadwalDipilih = null;
    });

    try {
      final hasil = await _jadwalService.ambilJadwalByTanggal(_tanggalDipilih!);
      setState(() {
        _daftarJadwal = hasil;
        _sedangMemuat = false;
      });
    } on ApiException catch (e) {
      setState(() {
        _daftarJadwal = [];
        _sedangMemuat = false;
        _pesanError = e.message;
      });
    } catch (e) {
      setState(() {
        _daftarJadwal = [];
        _sedangMemuat = false;
        _pesanError = 'Terjadi kesalahan tak terduga, coba lagi.';
      });
    }
  }

  void _gantiBulan(int delta) {
    setState(() {
      _bulanDitampilkan = DateTime(_bulanDitampilkan.year, _bulanDitampilkan.month + delta);
    });
  }

  Future<void> _pilihBulanTahun() async {
    final hasil = await showDialog<DateTime>(
      context: context,
      builder: (context) => _ModalPilihBulanTahun(
        tahunAwal: _bulanDitampilkan.year,
        bulanAwal: _bulanDitampilkan.month,
        namaBulan: _namaBulan,
      ),
    );
    if (hasil != null) {
      setState(() => _bulanDitampilkan = hasil);
    }
  }

  void _pilihTanggal(DateTime tanggal) {
    setState(() => _tanggalDipilih = tanggal);
    _muatJadwal();
  }

  void _lihatDetailLokasi(JadwalRingkas jadwal) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusL)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(jadwal.lokasi.namaLokasi,
                style: AppTextStyles.subheading.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Expanded(child: Text(jadwal.lokasi.alamat, style: AppTextStyles.body)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('${jadwal.jamMulaiFormat} - ${jadwal.jamSelesaiFormat}', style: AppTextStyles.body),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people_outline, size: 16, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text('Sisa kuota: ${jadwal.sisaKuota} dari ${jadwal.kuota}', style: AppTextStyles.body),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _selanjutnya() {
    if (_jadwalDipilih == null) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => KuisionerKesehatanPage(
          jadwalTerpilih: _jadwalDipilih!,
        ),
      ),
    );
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
                    judul: 'Jadwal & Lokasi Donor',
                    leadingIcon: Icons.arrow_back,
                    onTapLeading: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimens.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Silahkan pilih tanggal donor', style: AppTextStyles.caption),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(AppDimens.paddingM),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(AppDimens.radiusM),
                          ),
                          child: _KalenderDonor(
                            bulanDitampilkan: _bulanDitampilkan,
                            tanggalDipilih: _tanggalDipilih,
                            namaBulan: _namaBulan,
                            namaHari: _namaHari,
                            onGantiBulan: _gantiBulan,
                            onTapNamaBulan: _pilihBulanTahun,
                            onPilihTanggal: _pilihTanggal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppDimens.paddingM),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusM),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Silahkan pilih jadwal donor :', style: AppTextStyles.caption),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 340,
                          child: _buildDaftarJadwal(),
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
              onPressed: _jadwalDipilih == null ? null : _selanjutnya,
              child: const Text('Selanjutnya'),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDaftarJadwal() {
    if (_sedangMemuat) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pesanError != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_pesanError!, style: AppTextStyles.caption, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: _muatJadwal, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    if (_daftarJadwal.isEmpty) {
      return const Center(
        child: Text(
          'Tidak ada jadwal donor tersedia untuk tanggal ini',
          style: AppTextStyles.caption,
          textAlign: TextAlign.center,
        ),
      );
    }

    return Scrollbar(
      thumbVisibility: true,
      child: ListView.separated(
        padding: const EdgeInsets.only(right: 8),
        itemCount: _daftarJadwal.length,
        separatorBuilder: (context, i) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final jadwal = _daftarJadwal[i];
          final terpilih = _jadwalDipilih?.idJadwal == jadwal.idJadwal;
          return _KartuPilihJadwal(
            data: jadwal,
            terpilih: terpilih,
            onTapKartu: () => setState(() => _jadwalDipilih = jadwal),
            onCekDetail: () => _lihatDetailLokasi(jadwal),
          );
        },
      ),
    );
  }
}

class _KalenderDonor extends StatelessWidget {
  final DateTime bulanDitampilkan;
  final DateTime? tanggalDipilih;
  final List<String> namaBulan;
  final List<String> namaHari;
  final ValueChanged<int> onGantiBulan;
  final VoidCallback onTapNamaBulan;
  final ValueChanged<DateTime> onPilihTanggal;

  const _KalenderDonor({
    required this.bulanDitampilkan,
    required this.tanggalDipilih,
    required this.namaBulan,
    required this.namaHari,
    required this.onGantiBulan,
    required this.onTapNamaBulan,
    required this.onPilihTanggal,
  });

  @override
  Widget build(BuildContext context) {
    final tahun = bulanDitampilkan.year;
    final bulan = bulanDitampilkan.month;

    final hariPertama = DateTime(tahun, bulan, 1);
    final jumlahHariBulanIni = DateTime(tahun, bulan + 1, 0).day;
    final offsetAwal = hariPertama.weekday - 1;

    final totalSel = ((offsetAwal + jumlahHariBulanIni) / 7).ceil() * 7;
    final tanggalGrid = List<DateTime>.generate(
      totalSel,
      (i) => DateTime(tahun, bulan, 1 - offsetAwal + i),
    );

    return Column(
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onTapNamaBulan,
              child: Row(
                children: [
                  Text('${namaBulan[bulan - 1]} $tahun',
                      style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                  const Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
                ],
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => onGantiBulan(-1),
              child: const Icon(Icons.chevron_left, size: 18, color: AppColors.primary),
            ),
            GestureDetector(
              onTap: () => onGantiBulan(1),
              child: const Icon(Icons.chevron_right, size: 18, color: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 10),

        Row(
          children: namaHari
              .map((h) => Expanded(
                    child: Center(
                      child: Text(h, style: AppTextStyles.caption.copyWith(fontSize: 11)),
                    ),
                  ))
              .toList(),
        ),
        const SizedBox(height: 6),

        for (int minggu = 0; minggu < tanggalGrid.length / 7; minggu++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              children: List.generate(7, (i) {
                final tgl = tanggalGrid[minggu * 7 + i];
                final bulanBeda = tgl.month != bulan;
                final terpilih = tanggalDipilih != null &&
                    tgl.year == tanggalDipilih!.year &&
                    tgl.month == tanggalDipilih!.month &&
                    tgl.day == tanggalDipilih!.day;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onPilihTanggal(tgl),
                    child: Center(
                      child: Text(
                        '${tgl.day}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: terpilih ? FontWeight.bold : FontWeight.normal,
                          color: terpilih
                              ? AppColors.primary
                              : bulanBeda
                                  ? AppColors.textHint
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}

class _KartuPilihJadwal extends StatelessWidget {
  final JadwalRingkas data;
  final bool terpilih;
  final VoidCallback onTapKartu;
  final VoidCallback onCekDetail;

  const _KartuPilihJadwal({
    required this.data,
    required this.terpilih,
    required this.onTapKartu,
    required this.onCekDetail,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapKartu,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimens.paddingM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          border: Border.all(
            color: terpilih ? AppColors.primary : AppColors.border,
            width: terpilih ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimens.radiusS),
                  child: data.lokasi.fotoUrl != null
                      ? Image.network(
                          data.lokasi.fotoUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return Container(
                              width: 56,
                              height: 56,
                              color: AppColors.background,
                              child: const Center(
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 56,
                            height: 56,
                            color: AppColors.background,
                            child: const Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary),
                          ),
                        )
                      : Container(
                          width: 56,
                          height: 56,
                          color: AppColors.background,
                          child: const Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.lokasi.namaLokasi,
                          style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Expanded(child: Text(data.lokasi.alamat, style: AppTextStyles.caption)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text('${data.jamMulaiFormat} - ${data.jamSelesaiFormat}',
                              style: AppTextStyles.caption),
                          const SizedBox(width: 8),
                          Text('Sisa ${data.sisaKuota} kuota', style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(36),
                  shape: const StadiumBorder(),
                ),
                onPressed: onCekDetail,
                child: const Text('Cek Detail Lokasi', style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModalPilihBulanTahun extends StatefulWidget {
  final int tahunAwal;
  final int bulanAwal;
  final List<String> namaBulan;

  const _ModalPilihBulanTahun({
    required this.tahunAwal,
    required this.bulanAwal,
    required this.namaBulan,
  });

  @override
  State<_ModalPilihBulanTahun> createState() => _ModalPilihBulanTahunState();
}

class _ModalPilihBulanTahunState extends State<_ModalPilihBulanTahun> {
  late int _tahun = widget.tahunAwal;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 100),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _tahun--),
                  child: const Icon(Icons.chevron_left, color: AppColors.primary),
                ),
                const SizedBox(width: 16),
                Text('$_tahun', style: AppTextStyles.subheading),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: () => setState(() => _tahun++),
                  child: const Icon(Icons.chevron_right, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 16),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2.2,
              ),
              itemCount: 12,
              itemBuilder: (context, i) {
                final bulanIni = i + 1;
                final terpilih = bulanIni == widget.bulanAwal && _tahun == widget.tahunAwal;
                return GestureDetector(
                  onTap: () => Navigator.of(context).pop(DateTime(_tahun, bulanIni)),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: terpilih ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimens.radiusS),
                      border: Border.all(color: terpilih ? AppColors.primary : AppColors.border),
                    ),
                    child: Text(
                      widget.namaBulan[i].substring(0, 3),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: terpilih ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}