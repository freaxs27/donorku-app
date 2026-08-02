import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../model/riwayat_donor.dart';
import '../../model/item_pendaftaran.dart';
import '../../services/riwayat/riwayat_service.dart';
import '../../services/core/api_exception.dart';

/// Halaman Riwayat (RW-001) — dua tab: Donor & Pendaftaran.
class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  // ── Tab ──────────────────────────────────────────────────────────────────
  int _tabAktif = 0; // 0 = Donor, 1 = Pendaftaran

  // ── Tab Donor ─────────────────────────────────────────────────────────────
  static const List<_FilterChipData> _filters = [
    _FilterChipData(id: 'all',     label: 'ALL'),
    _FilterChipData(id: '1bulan',  label: '1 Bulan Terakhir'),
    _FilterChipData(id: '6bulan',  label: '6 Bulan Terakhir'),
    _FilterChipData(id: '1tahun',  label: '1 Tahun Terakhir'),
  ];

  final RiwayatService _service = RiwayatService();

  String _filterAktif = 'all';
  bool _sedangMemuatDonor = false;
  String? _pesanErrorDonor;
  RiwayatResponse? _dataDonor;

  // ── Tab Pendaftaran ───────────────────────────────────────────────────────
  bool _sedangMemuatDaftar = false;
  String? _pesanErrorDaftar;
  List<ItemPendaftaran> _dataDaftar = [];
  int? _sedangBatalkan;

  @override
  void initState() {
    super.initState();
    _muatDonor();
    _muatDaftar();
  }

  // ── Loader: Donor ─────────────────────────────────────────────────────────
  Future<void> _muatDonor() async {
    setState(() { _sedangMemuatDonor = true; _pesanErrorDonor = null; });
    try {
      final hasil = await _service.ambilRiwayat(_filterAktif);
      if (!mounted) return;
      setState(() => _dataDonor = hasil);
    } on ApiException catch (e) {
      if (e.statusCode == 401 || !mounted) return;
      setState(() => _pesanErrorDonor = e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _pesanErrorDonor = 'Terjadi kesalahan, coba lagi.');
    } finally {
      if (mounted) setState(() => _sedangMemuatDonor = false);
    }
  }

  // ── Loader: Pendaftaran ───────────────────────────────────────────────────
  Future<void> _muatDaftar() async {
    setState(() { _sedangMemuatDaftar = true; _pesanErrorDaftar = null; });
    try {
      final hasil = await _service.ambilDaftarPendaftaran();
      if (!mounted) return;
      setState(() => _dataDaftar = hasil);
    } on ApiException catch (e) {
      if (e.statusCode == 401 || !mounted) return;
      setState(() => _pesanErrorDaftar = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _pesanErrorDaftar = 'Terjadi kesalahan, coba lagi.');
    } finally {
      if (mounted) setState(() => _sedangMemuatDaftar = false);
    }
  }

  void _gantiFilter(String id) {
    if (id == _filterAktif) return;
    setState(() => _filterAktif = id);
    _muatDonor();
  }

  Future<void> _batalkan(ItemPendaftaran item) async {
    final konfirmasi = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Batalkan Pendaftaran?'),
        content: Text(
          'Yakin ingin membatalkan pendaftaran donor di ${item.jadwal.lokasi} '
          'pada ${item.jadwal.tanggalFormat}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Ya, Batalkan',
                style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
    if (konfirmasi != true) return;

    setState(() => _sedangBatalkan = item.idPendaftaran);
    try {
      await _service.batalkanPendaftaran(item.idPendaftaran);
      await _muatDaftar();
    } on ApiException catch (e) {
      if (e.statusCode == 401 || !mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membatalkan, coba lagi.')),
        );
      }
    } finally {
      if (mounted) setState(() => _sedangBatalkan = null);
    }
  }

  String _formatTanggalBolehDonor(DateTime? t) {
    if (t == null) return 'Sekarang';
    const bulan = [
      'Januari','Februari','Maret','April','Mei','Juni',
      'Juli','Agustus','September','Oktober','November','Desember',
    ];
    return '${t.day} ${bulan[t.month - 1]} ${t.year}';
  }

  String _labelSkrining(String? s) => switch (s) {
        'negatif' => 'Negatif',
        'positif' => 'Positif',
        'pending'  => 'Pending',
        _          => '-',
      };

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          // Judul
          const Padding(
            padding: EdgeInsets.fromLTRB(
                AppDimens.paddingL, AppDimens.paddingM, AppDimens.paddingL, 0),
            child: HeaderHalaman(judul: 'Riwayat Donor'),
          ),

          const SizedBox(height: 14),

          // Tab pill switcher
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
            child: Container(
              height: 36,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: Offset.zero,
                  ),
                ],
              ),
              child: Row(
                children: [
                  _PillTab(
                    label: 'Riwayat Donor',
                    aktif: _tabAktif == 0,
                    onTap: () => setState(() => _tabAktif = 0),
                  ),
                  _PillTab(
                    label: 'Pendaftaran',
                    aktif: _tabAktif == 1,
                    onTap: () => setState(() => _tabAktif = 1),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 4),

          // Konten tab
          Expanded(
            child: _tabAktif == 0 ? _buildTabDonor() : _buildTabDaftar(),
          ),
        ],
      ),
    );
  }

  // ── Tab Donor ─────────────────────────────────────────────────────────────
  Widget _buildTabDonor() {
    if (_sedangMemuatDonor) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pesanErrorDonor != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_pesanErrorDonor!, style: AppTextStyles.caption,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: _muatDonor, child: const Text('Coba lagi')),
          ],
        ),
      );
    }

    final data = _dataDonor;
    if (data == null) return const SizedBox.shrink();

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
          AppDimens.paddingL, 16, AppDimens.paddingL, AppDimens.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _KartuRingkasan(totalDonasi: data.totalDonasi, totalMl: data.totalMlDarah),
          const SizedBox(height: 12),
          _KartuDonorKembali(
            tanggal: data.bolehDonorSekarang
                ? 'Sekarang'
                : _formatTanggalBolehDonor(data.tanggalBolehDonor),
          ),
          const SizedBox(height: 16),
          _BarisFilter(
            filters: _filters,
            aktif: _filterAktif,
            onPilih: _gantiFilter,
          ),
          const SizedBox(height: 16),
          if (data.statusKesehatan != null) ...[
            _KartuStatusKesehatan(
              hemoglobin: data.statusKesehatan!.hemoglobin ?? '-',
              tekananDarah: data.statusKesehatan!.tekananDarahFormat ?? '-',
              hasilTes: _labelSkrining(data.statusKesehatan!.statusSkrining),
            ),
            const SizedBox(height: 12),
          ],
          if (data.riwayat.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Center(
                child: Text('Belum ada riwayat donor pada periode ini',
                    style: AppTextStyles.caption, textAlign: TextAlign.center),
              ),
            )
          else
            for (final item in data.riwayat) ...[
              _KartuRiwayat(item: item),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  // ── Tab Pendaftaran ───────────────────────────────────────────────────────
  Widget _buildTabDaftar() {
    if (_sedangMemuatDaftar) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_pesanErrorDaftar != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_pesanErrorDaftar!, style: AppTextStyles.caption,
                textAlign: TextAlign.center),
            const SizedBox(height: 8),
            TextButton(onPressed: _muatDaftar, child: const Text('Coba lagi')),
          ],
        ),
      );
    }
    if (_dataDaftar.isEmpty) {
      return const Center(
        child: Text('Belum ada pendaftaran donor',
            style: AppTextStyles.caption),
      );
    }

    return RefreshIndicator(
      onRefresh: _muatDaftar,
      child: ListView.separated(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        itemCount: _dataDaftar.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, i) {
          final item = _dataDaftar[i];
          return _KartuPendaftaran(
            item: item,
            sedangBatalkan: _sedangBatalkan == item.idPendaftaran,
            onBatalkan: () => _batalkan(item),
          );
        },
      ),
    );
  }
}

// ── Pill Tab ──────────────────────────────────────────────────────────────────
class _PillTab extends StatelessWidget {
  final String label;
  final bool aktif;
  final VoidCallback onTap;

  const _PillTab({required this.label, required this.aktif, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: aktif ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: aktif ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Kartu Pendaftaran ─────────────────────────────────────────────────────────
class _KartuPendaftaran extends StatelessWidget {
  final ItemPendaftaran item;
  final bool sedangBatalkan;
  final VoidCallback onBatalkan;

  const _KartuPendaftaran({
    required this.item,
    required this.sedangBatalkan,
    required this.onBatalkan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: Offset.zero,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.local_hospital_outlined,
                  size: 18, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(item.jadwal.lokasi,
                    style: AppTextStyles.body
                        .copyWith(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              _BadgeStatus(label: item.statusLabel, warna: item.warnaStatus),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.border),
          const SizedBox(height: 8),
          _baris(Icons.calendar_today_outlined, item.jadwal.tanggalFormat),
          const SizedBox(height: 4),
          _baris(Icons.access_time,
              '${item.jadwal.jamMulai} - ${item.jadwal.jamSelesai}'),
          const SizedBox(height: 4),
          _baris(Icons.confirmation_number_outlined,
              'Antrian #${item.nomorAntrian}'),
          if (item.riwayat?.darahTerkumpul != null) ...[
            const SizedBox(height: 4),
            _baris(Icons.water_drop_outlined,
                '${item.riwayat!.darahTerkumpul} ml'),
          ],
          if (item.bisaDibatalkan) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  minimumSize: const Size.fromHeight(36),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusM)),
                ),
                onPressed: sedangBatalkan ? null : onBatalkan,
                child: sedangBatalkan
                    ? const SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: AppColors.primary))
                    : const Text('Batalkan Pendaftaran',
                        style: TextStyle(fontSize: 13)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _baris(IconData icon, String teks) {
    return Row(
      children: [
        Icon(icon, size: 14, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Text(teks, style: AppTextStyles.caption),
      ],
    );
  }
}

class _BadgeStatus extends StatelessWidget {
  final String label;
  final StatusWarna warna;

  const _BadgeStatus({required this.label, required this.warna});

  @override
  Widget build(BuildContext context) {
    final Color bg = switch (warna) {
      StatusWarna.hijau  => const Color(0xFFE6F4EA),
      StatusWarna.merah  => const Color(0xFFFFEBEE),
      StatusWarna.kuning => const Color(0xFFFFF8E1),
      StatusWarna.biru   => const Color(0xFFE3F2FD),
      StatusWarna.abu    => const Color(0xFFF5F5F5),
    };
    final Color fg = switch (warna) {
      StatusWarna.hijau  => const Color(0xFF2E7D32),
      StatusWarna.merah  => const Color(0xFFC62828),
      StatusWarna.kuning => const Color(0xFFF57F17),
      StatusWarna.biru   => const Color(0xFF1565C0),
      StatusWarna.abu    => const Color(0xFF757575),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}

// ── Data classes ──────────────────────────────────────────────────────────────
class _FilterChipData {
  final String id;
  final String label;
  const _FilterChipData({required this.id, required this.label});
}

// ── Dekorasi kartu ────────────────────────────────────────────────────────────
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

// ── Kartu Ringkasan ───────────────────────────────────────────────────────────
class _KartuRingkasan extends StatelessWidget {
  final int totalDonasi;
  final int totalMl;
  const _KartuRingkasan({required this.totalDonasi, required this.totalMl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          Expanded(
            child: Column(children: [
              Text('$totalDonasi',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold,
                      color: AppColors.primary, height: 1)),
              const SizedBox(height: 4),
              Text('Total Donasi',
                  style: AppTextStyles.caption.copyWith(fontSize: 10)),
            ]),
          ),
          Container(width: 1, height: 56, color: AppColors.border),
          Expanded(
            child: Column(children: [
              Text('$totalMl',
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold,
                      color: AppColors.primary, height: 1)),
              const SizedBox(height: 4),
              Text('ml Darah',
                  style: AppTextStyles.caption.copyWith(fontSize: 10)),
            ]),
          ),
        ],
      ),
    );
  }
}

// ── Kartu Donor Kembali ───────────────────────────────────────────────────────
class _KartuDonorKembali extends StatelessWidget {
  final String tanggal;
  const _KartuDonorKembali({required this.tanggal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          const Icon(Icons.calendar_today_outlined,
              size: 30, color: AppColors.textPrimary),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Dapat Donor Kembali', style: AppTextStyles.body),
            const SizedBox(height: 2),
            Text(tanggal,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600,
                    color: AppColors.primary)),
          ]),
        ],
      ),
    );
  }
}

// ── Baris Filter ─────────────────────────────────────────────────────────────
class _BarisFilter extends StatelessWidget {
  final List<_FilterChipData> filters;
  final String aktif;
  final ValueChanged<String> onPilih;

  const _BarisFilter(
      {required this.filters, required this.aktif, required this.onPilih});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (int i = 0; i < filters.length; i++) ...[
            _ChipFilter(
              label: filters[i].label,
              isAktif: filters[i].id == aktif,
              onTap: () => onPilih(filters[i].id),
              sempit: filters[i].id == 'all',
            ),
            if (i != filters.length - 1) const SizedBox(width: 6),
          ],
        ],
      ),
    );
  }
}

class _ChipFilter extends StatelessWidget {
  final String label;
  final bool isAktif;
  final VoidCallback onTap;
  final bool sempit;

  const _ChipFilter({
    required this.label, required this.isAktif,
    required this.onTap, this.sempit = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 18,
        width: sempit ? 43 : 100,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isAktif ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 4, offset: Offset.zero,
            ),
          ],
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w400,
              color: isAktif ? Colors.white : AppColors.textPrimary,
            )),
      ),
    );
  }
}

// ── Kartu Status Kesehatan ────────────────────────────────────────────────────
class _KartuStatusKesehatan extends StatelessWidget {
  final String hemoglobin;
  final String tekananDarah;
  final String hasilTes;

  const _KartuStatusKesehatan({
    required this.hemoglobin,
    required this.tekananDarah,
    required this.hasilTes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: _dekorasiKartu,
      child: Column(
        children: [
          Container(
            height: 26, width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD8D8),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 4, offset: Offset.zero),
              ],
            ),
            child: Row(children: [
              Image.asset('assets/icons/riwayat/tekanan_darah.png',
                  width: 18, height: 18),
              const SizedBox(width: 8),
              const Text('Status Kesehatan',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
            ]),
          ),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(
              child: _MiniMetrik(
                iconAsset: 'assets/icons/riwayat/hemoglobin.png',
                baris1: Text.rich(TextSpan(children: [
                  const TextSpan(text: 'Hemoglobin\n',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                  TextSpan(text: hemoglobin,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                  const TextSpan(text: ' g/dL',
                      style: TextStyle(fontSize: 7, fontWeight: FontWeight.w400)),
                ])),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _MiniMetrik(
                iconAsset: 'assets/icons/riwayat/tekanan_darah.png',
                baris1: Text.rich(TextSpan(children: [
                  TextSpan(text: tekananDarah,
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                  const TextSpan(text: ' mmHg\n',
                      style: TextStyle(fontSize: 7, fontWeight: FontWeight.w400)),
                  const TextSpan(text: 'Normal',
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
                ])),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: _MiniMetrik(
                iconAsset: 'assets/icons/riwayat/hasil_tes.png',
                baris1: Text(hasilTes,
                    style: const TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w600)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _MiniMetrik extends StatelessWidget {
  final String iconAsset;
  final Widget baris1;

  const _MiniMetrik({required this.iconAsset, required this.baris1});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFDFDFD),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 2, offset: Offset.zero),
        ],
      ),
      child: Row(children: [
        Image.asset(iconAsset, width: 18, height: 18),
        const SizedBox(width: 4),
        Expanded(child: baris1),
      ]),
    );
  }
}

// ── Kartu Riwayat Donor ───────────────────────────────────────────────────────
class _KartuRiwayat extends StatelessWidget {
  final ItemRiwayat item;
  const _KartuRiwayat({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 99,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _dekorasiKartu,
      child: Row(
        children: [
          SizedBox(
            width: 74, height: 74,
            child: SvgPicture.asset('assets/icons/riwayat/blood_drop.svg',
                width: 74, height: 74, fit: BoxFit.contain),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.tanggalFormat,
                    style: AppTextStyles.body
                        .copyWith(fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Row(children: [
                  Expanded(
                    child: Text(item.lokasiDonor,
                        style: AppTextStyles.body.copyWith(fontSize: 14),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48, height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4, offset: Offset.zero),
                      ],
                    ),
                    child: const Text('-',
                        style: TextStyle(fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary)),
                  ),
                ]),
                const SizedBox(height: 6),
                Row(children: [
                  Text(item.volumeLabel,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 36),
                  Text(item.statusLabel,
                      style: const TextStyle(
                          fontSize: 10, fontWeight: FontWeight.w500)),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}