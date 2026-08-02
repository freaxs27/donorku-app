import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../widgets/header_halaman.dart';
import '../../model/lokasi_donor.dart';
import '../../services/lokasi/lokasi_service.dart';
import '../../services/core/api_exception.dart';

// (LK-001 - LK-004).
class LokasiPage extends StatefulWidget {
  final LokasiDonor? lokasiAwal;

  const LokasiPage({super.key, this.lokasiAwal});

  @override
  State<LokasiPage> createState() => _LokasiPageState();
}

class _LokasiPageState extends State<LokasiPage> with TickerProviderStateMixin {
  static const double _sheetMinAbsolut = 0.18; // batas paling kecil sheet bisa di-drag
  static const double _sheetAwal = 0.32; // tinggi saat tampil 2 kartu awal (LK-001)
  static const double _sheetSatuKartu = 0.25; // tinggi saat 1 lokasi terpilih (LK-002)
  static const double _sheetMax = 1; // tinggi saat expand penuh (LK-003/004)
  static const LatLng _pusatDefault = LatLng(-6.9040, 107.6140);

  final MapController _mapController = MapController();
  final DraggableScrollableController _sheetController = DraggableScrollableController();
  final LokasiService _lokasiService = LokasiService();
  final TextEditingController _searchController = TextEditingController();

  LokasiDonor? _lokasiTerpilih;
  late double _sheetExtent;
  double _opasitasMarker = 1;

  List<LokasiDonor> _semuaLokasi = [];
  bool _sedangMuat = true;
  String? _pesanError;

  @override
  void initState() {
    super.initState();
    _lokasiTerpilih = widget.lokasiAwal;
    _sheetExtent = widget.lokasiAwal != null ? _sheetSatuKartu : _sheetAwal;
    _muatData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _muatData({String? search}) async {
    setState(() {
      _sedangMuat = true;
      _pesanError = null;
    });

    try {
      final daftar = await _lokasiService.ambilDaftarLokasi(search: search);
      if (!mounted) return;
      setState(() {
        _semuaLokasi = daftar;
        _sedangMuat = false;
      });
    } on ApiException catch (e) {
      if (e.statusCode == 401 || !mounted) return;
      setState(() {
        _pesanError = e.message;
        _sedangMuat = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _pesanError = 'Gagal memuat data lokasi, coba lagi';
        _sedangMuat = false;
      });
    }
  }

  bool get _sheetTerbuka => _sheetExtent > (_sheetAwal + _sheetMax) / 2;


  void _pilihLokasi(LokasiDonor lokasi) {
    final posisiAwal = _mapController.camera.center;
    final zoomAwal = _mapController.camera.zoom;
    final rotasiAwal = _mapController.camera.rotation;

    final tweenPosisi = _LatLngTween(begin: posisiAwal, end: lokasi.posisi);
    final tweenZoom = Tween<double>(begin: zoomAwal, end: 16);
    final tweenRotasi = Tween<double>(begin: rotasiAwal, end: 0);

    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    final animasi = CurvedAnimation(parent: controller, curve: Curves.easeInOutCubic);
    setState(() {
      _lokasiTerpilih = lokasi;
      _opasitasMarker = 0;
    });

    controller.addListener(() {
      _mapController.moveAndRotate(
        tweenPosisi.evaluate(animasi),
        tweenZoom.evaluate(animasi),
        tweenRotasi.evaluate(animasi),
      );
      final t = ((animasi.value - 0.4) / 0.6).clamp(0.0, 1.0);
      if (t != _opasitasMarker) {
        setState(() => _opasitasMarker = t);
      }
    });

    controller.forward().whenComplete(() => controller.dispose());

    _sheetController.animateTo(
      _sheetSatuKartu,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }


  void _kembaliKeAwal() {
    if (_lokasiTerpilih == null) return;
    setState(() => _lokasiTerpilih = null);
    _sheetController.animateTo(
      _sheetAwal,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _toggleSheet() {
    final target = _sheetTerbuka ? _sheetAwal : _sheetMax;
    setState(() => _lokasiTerpilih = null); 
    _sheetController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_sedangMuat && _semuaLokasi.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_pesanError != null && _semuaLokasi.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppDimens.paddingL),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_pesanError!, textAlign: TextAlign.center, style: AppTextStyles.body),
                const SizedBox(height: 12),
                ElevatedButton(onPressed: () => _muatData(), child: const Text('Coba Lagi')),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: _kembaliKeAwal,
        behavior: HitTestBehavior.translucent,
        child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.lokasiAwal?.posisi ?? _pusatDefault,
              initialZoom: widget.lokasiAwal != null ? 16 : 14,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.donorku_app',
              ),
              MarkerLayer(
                markers: _lokasiTerpilih != null
                    ? [
                        Marker(
                          point: _lokasiTerpilih!.posisi,
                          width: 44,
                          height: 44,
                          child: Opacity(
                            opacity: _opasitasMarker,
                            child: const Icon(Icons.location_on, color: AppColors.primary, size: 44),
                          ),
                        ),
                      ]
                    : _semuaLokasi
                        .map(
                          (l) => Marker(
                            point: l.posisi,
                            width: 16,
                            height: 16,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border: Border.all(color: AppColors.textSecondary),
                              ),
                            ),
                          ),
                        )
                        .toList(),
              ),
            ],
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 44, AppDimens.paddingL, 0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8)],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.textSecondary, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: (teks) => _muatData(search: teks),
                        decoration: const InputDecoration(
                          hintText: 'Cari Disini',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        FocusScope.of(context).unfocus();
                        _muatData();
                      },
                      child: const Icon(Icons.close, color: AppColors.textSecondary, size: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),

          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notif) {
              setState(() => _sheetExtent = notif.extent);
              return true;
            },
            child: DraggableScrollableSheet(
              controller: _sheetController,
              initialChildSize: _sheetExtent,
              minChildSize: _sheetMinAbsolut,
              maxChildSize: _sheetMax,
              builder: (context, scrollController) {
                final List<LokasiDonor> daftarDitampilkan;
                if (_sheetTerbuka) {
                  daftarDitampilkan = _semuaLokasi; 
                } else if (_lokasiTerpilih != null) {
                  daftarDitampilkan = [_lokasiTerpilih!]; 
                } else {
                  daftarDitampilkan = _semuaLokasi.take(2).toList();
                }

                return Container(
                  padding: EdgeInsets.only(top: _sheetTerbuka ? 25 : 0), 
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(AppDimens.radiusL)),
                  ),
                  child: Column(
                    children: [
                      if (_sheetTerbuka)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppDimens.paddingM, 12, AppDimens.paddingM, 0,
                          ),
                          child: HeaderHalaman(
                            judul: 'Lokasi',
                            leadingIcon: Icons.arrow_back,
                            onTapLeading: _toggleSheet,
                          ),
                        ),
                      GestureDetector(
                        onTap: _toggleSheet,
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Container(
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(
                                color: Colors.black26,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          controller: scrollController,
                          padding: const EdgeInsets.fromLTRB(
                            AppDimens.paddingL, 0, AppDimens.paddingL, 24,
                          ),
                          itemCount: daftarDitampilkan.length,
                          separatorBuilder: (context, i) => const SizedBox(height: 12),
                          itemBuilder: (context, i) {
                            return _KartuLokasiPeta(
                              data: daftarDitampilkan[i],
                              onCekDetail: () => _pilihLokasi(daftarDitampilkan[i]),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (!_sheetTerbuka)
            _HeaderLokasi(
              tampilkanPanah: widget.lokasiAwal != null,
              onTapBack: widget.lokasiAwal != null
                  ? () => Navigator.of(context).pop()
                  : _toggleSheet,
            ),
        ],
      ),
      ),
    );
  }
}

class _HeaderLokasi extends StatelessWidget {
  final bool tampilkanPanah;
  final VoidCallback onTapBack;

  const _HeaderLokasi({required this.tampilkanPanah, required this.onTapBack});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL, vertical: 4),
        child: HeaderHalaman(
          judul: 'Lokasi',
          leadingIcon: tampilkanPanah ? Icons.arrow_back : null,
          onTapLeading: onTapBack,
        ),
      ),
    );
  }
}

class _KartuLokasiPeta extends StatelessWidget {
  final LokasiDonor data;
  final VoidCallback onCekDetail;

  const _KartuLokasiPeta({required this.data, required this.onCekDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
                child: data.fotoUrl != null
                    ? Image.network(
                        data.fotoUrl!,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return Container(
                            width: 72,
                            height: 72,
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
                          width: 72,
                          height: 72,
                          color: AppColors.background,
                          child: const Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary),
                        ),
                      )
                    : data.fotoAsset != null
                        ? Image.asset(data.fotoAsset!, width: 72, height: 72, fit: BoxFit.cover)
                        : Container(
                            width: 72,
                            height: 72,
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
                    Text(data.nama, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                        const SizedBox(width: 2),
                        Expanded(child: Text(data.alamat, style: AppTextStyles.caption)),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data.statusDonor ?? 'Open Donor Darah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: data.statusDonor == 'Belum Ada Jadwal'
                            ? AppColors.textSecondary
                            : AppColors.textPrimary,
                      ),
                    ),
                    if (data.jadwalLabel != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Text(data.jadwalLabel!,
                              style: AppTextStyles.caption),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40),
                shape: const StadiumBorder(),
              ),
              onPressed: onCekDetail,
              child: const Text('Cek Detail Lokasi'),
            ),
          ),
        ],
      ),
    );
  }
}

class _LatLngTween extends Tween<LatLng> {
  _LatLngTween({required LatLng begin, required LatLng end}) : super(begin: begin, end: end);

  @override
  LatLng lerp(double t) {
    final lat = begin!.latitude + (end!.latitude - begin!.latitude) * t;
    final lng = begin!.longitude + (end!.longitude - begin!.longitude) * t;
    return LatLng(lat, lng);
  }
}