import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../model/beranda_data.dart';
import '../../model/data_notifikasi.dart';
import '../../services/beranda/beranda_service.dart';
import '../../services/notifikasi/notifikasi_service.dart';
import '../../services/core/api_exception.dart';
import '../../widgets/main_layout.dart';
import '../bantuan/reza_chatbot_page.dart';
import '../bantuan/chat_cs.dart';

/// Halaman Beranda (D-001 / B-001 - keduanya desain yang sama).
class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final BerandaService _berandaService = BerandaService();

  BerandaData? _data;
  bool _sedangMuat = true;
  String? _pesanError;
  List<LokasiRingkas> _lokasiTerdekat = [];

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    setState(() {
      _sedangMuat = true;
      _pesanError = null;
    });

    try {
      final data = await _berandaService.ambilDataBeranda();
      if (!mounted) return;

      final posisi = await _ambilPosisiUser();
      final terdekat = _urutkanTerdekat(data.lokasiTersedia, posisi);

      if (!mounted) return;
      setState(() {
        _data = data;
        _lokasiTerdekat = terdekat;
        _sedangMuat = false;
      });
    } on ApiException catch (e) {
      // 401 sudah diurus ApiClient (clear sesi + redirect Login).
      if (e.statusCode == 401 || !mounted) return;
      setState(() {
        _pesanError = e.message;
        _sedangMuat = false;
      });
    } catch (e) {
      debugPrint('Error ambil data beranda: $e');
      if (!mounted) return;
      setState(() {
        _pesanError = AppStrings.of(context).loadDataFailed;
        _sedangMuat = false;
      });
    }
  }

  /// Ambil posisi GPS user saat ini. Return null kalau layanan lokasi
  /// mati, izin ditolak, atau gagal (timeout dsb.) -- supaya halaman
  /// tetap bisa jalan (fallback ke urutan apa adanya dari API) tanpa
  /// bikin seluruh Beranda gagal cuma gara-gara lokasi tidak tersedia.
  Future<Position?> _ambilPosisiUser() async {
    try {
      final layananAktif = await Geolocator.isLocationServiceEnabled();
      if (!layananAktif) return null;

      LocationPermission izin = await Geolocator.checkPermission();
      if (izin == LocationPermission.denied) {
        izin = await Geolocator.requestPermission();
        if (izin == LocationPermission.denied) return null;
      }
      if (izin == LocationPermission.deniedForever) return null;

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.medium),
      ).timeout(const Duration(seconds: 8));
    } catch (e) {
      debugPrint('Gagal ambil lokasi user: $e');
      return null;
    }
  }

  /// Urutkan lokasi berdasarkan jarak terdekat ke posisi user, ambil 2
  /// teratas saja. Kalau posisi user tidak tersedia (null), atau lokasi
  /// tidak punya koordinat, fallback ambil 2 pertama apa adanya dari API.
  List<LokasiRingkas> _urutkanTerdekat(List<LokasiRingkas> semua, Position? posisi) {
    if (posisi == null) return semua.take(2).toList();

    final punyaKoordinat = semua.where((l) => l.latitude != null && l.longitude != null).toList();
    if (punyaKoordinat.isEmpty) return semua.take(2).toList();

    punyaKoordinat.sort((a, b) {
      final jarakA = Geolocator.distanceBetween(
        posisi.latitude, posisi.longitude, a.latitude!, a.longitude!,
      );
      final jarakB = Geolocator.distanceBetween(
        posisi.latitude, posisi.longitude, b.latitude!, b.longitude!,
      );
      return jarakA.compareTo(jarakB);
    });

    return punyaKoordinat.take(2).toList();
  }

  void _bukaNotifikasi(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true, // tap di luar modal = otomatis menutup
      builder: (context) => const _NotifikasiModal(),
    );
    // Setelah modal tertutup (baik lewat tombol X atau tap di luar),
    // pastikan tidak ada widget yang otomatis dapat fokus keyboard.
    if (context.mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);

    if (_sedangMuat) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pesanError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_pesanError!, textAlign: TextAlign.center, style: AppTextStyles.body),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _muatData, child: Text(s.tryAgainButton)),
            ],
          ),
        ),
      );
    }

    final data = _data!;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _muatData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppDimens.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: sapaan + logo kecil + icon notifikasi
              Row(
                children: [
                  Expanded(
                    child: Text(s.greetingHello(data.namaLengkap), style: AppTextStyles.heading),
                  ),
                  Image.asset('assets/images/logo.png', height: 28),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _bukaNotifikasi(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surface,
                      ),
                      child: const Icon(Icons.notifications_none, size: 20),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _KartuMulaiDonor(
                onTapDaftar: () => MainLayoutScope.of(context)?.pindahTab(2),
              ),
              const SizedBox(height: 20),

              _KartuAndaSudahDonor(
                totalDonasi: data.totalDonasi,
                totalMlDarah: data.totalMlDarah,
                bolehDonorSekarang: data.bolehDonorSekarang,
                tanggalBolehDonor: data.tanggalBolehDonor,
              ),
              const SizedBox(height: 20),

              _KartuLokasiTersedia(
                daftarLokasi: _lokasiTerdekat
                    .map((l) => _DataLokasi(
                          nama: l.namaLokasi,
                          alamat: l.alamat,
                          fotoUrl: l.fotoUrl,
                          jamMulai: l.jamMulai,
                          jamSelesai: l.jamSelesai,
                          sisaKuota: l.sisaKuota,
                          tanggalPelaksanaan: l.tanggalFormat,
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),

              _KartuChat(
                judul: s.chatRezaTitle,
                subjudul: s.chatRezaSubtitle,
                iconAssetPath: null,
                onTapPanah: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const RezaChatbotPage()),
                ),
                onKirimPesan: (pesan) => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const RezaChatbotPage()),
                ),
              ),
              const SizedBox(height: 12),
              _KartuChat(
                judul: s.chatAdminTitle,
                subjudul: s.chatAdminSubtitle,
                iconAssetPath: 'assets/icons/bantuan/admin.png',
                onTapPanah: () => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const ChatCsPage()),
                ),
                onKirimPesan: (_) => Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const ChatCsPage()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Judul seksi + panah kecil di kanan (mis. "Anda Sudah Donor  ->")
class _JudulSeksi extends StatelessWidget {
  final String judul;
  const _JudulSeksi({required this.judul});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(judul, style: AppTextStyles.subheading)),
        const Icon(Icons.arrow_forward, size: 18),
      ],
    );
  }
}

/// Kartu "Mulai Donorkan Darahmu" dengan ilustrasi + tombol Daftar Donor.
class _KartuMulaiDonor extends StatelessWidget {
  final VoidCallback onTapDaftar;
  const _KartuMulaiDonor({required this.onTapDaftar});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: Container(
        width: double.infinity, // kartu selalu selebar induknya
        color: AppColors.surface,
        child: Stack(
          children: [
            // Ilustrasi diperbesar & diposisikan "bleed" ke pojok
            // kanan-bawah kartu, sebagian terpotong oleh ClipRRect
            // di atas -- supaya kesannya penuh seperti di desain.
            Positioned(
              right: -16,
              bottom: -10,
              child: Image.asset(
                'assets/images/ilustrasi_donor.png',
                width: 170,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimens.paddingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Lebar teks dibatasi supaya tidak ketiban ilustrasi
                  // yang sekarang lebih besar & nyender ke kanan.
                  SizedBox(
                    width: 190,
                    child: Text(s.startDonatingTitle, style: AppTextStyles.subheading),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 190,
                    child: Text(
                      s.startDonatingSubtitle,
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(140, 40)),
                    onPressed: onTapDaftar,
                    child: Text(s.registerDonorButton),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Kartu besar "Anda Sudah Donor", di dalamnya ada 2 kartu kecil:
/// (1) statistik Total Donasi + ml Darah, (2) info Dapat Donor Kembali
/// (atau "boleh donor sekarang" kalau sudah waktunya).
class _KartuAndaSudahDonor extends StatelessWidget {
  final int totalDonasi;
  final int totalMlDarah;
  final bool bolehDonorSekarang;
  final DateTime? tanggalBolehDonor;

  const _KartuAndaSudahDonor({
    required this.totalDonasi,
    required this.totalMlDarah,
    required this.bolehDonorSekarang,
    required this.tanggalBolehDonor,
  });

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _JudulSeksi(judul: s.youHaveDonatedTitle),
          const SizedBox(height: 12),

          // Kartu kecil 1: statistik Total Donasi & ml Darah
          Container(
            padding: const EdgeInsets.all(AppDimens.paddingM),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text('$totalDonasi', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text(s.totalDonations, style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 40, child: VerticalDivider(color: AppColors.border)),
                Expanded(
                  child: Column(
                    children: [
                      Text('$totalMlDarah', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text(s.mlBlood, style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Kartu kecil 2: Dapat Donor Kembali (diperbesar sesuai desain)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            child: Row(
              children: [
                Icon(
                  bolehDonorSekarang ? Icons.check_circle_outline : Icons.calendar_today_outlined,
                  size: 26,
                  color: bolehDonorSekarang ? AppColors.success : AppColors.textPrimary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bolehDonorSekarang ? s.canDonateNow : s.canDonateAgain,
                        style: AppTextStyles.body,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        bolehDonorSekarang
                            ? s.nowExclaim
                            : (tanggalBolehDonor != null ? s.formatTanggal(tanggalBolehDonor!) : '-'),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Data sederhana untuk 1 lokasi donor.
class _DataLokasi {
  final String nama;
  final String alamat;
  final String? fotoAsset;
  final String? fotoUrl;
  final String? jamMulai;
  final String? jamSelesai;
  final int? sisaKuota;
  final String? tanggalPelaksanaan;

  const _DataLokasi({
    required this.nama,
    required this.alamat,
    this.fotoUrl,
    this.jamMulai,
    this.jamSelesai,
    this.sisaKuota,
    this.tanggalPelaksanaan,
  }) : fotoAsset = null;
}

/// Kartu besar "Lokasi Tersedia Donor Darah", di dalamnya ada kartu kecil
/// untuk tiap lokasi.
class _KartuLokasiTersedia extends StatelessWidget {
  final List<_DataLokasi> daftarLokasi;
  const _KartuLokasiTersedia({required this.daftarLokasi});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _JudulSeksi(judul: s.availableLocationsTitle),
          const SizedBox(height: 12),
          for (int i = 0; i < daftarLokasi.length; i++) ...[
            _KartuLokasiItem(data: daftarLokasi[i]),
            if (i != daftarLokasi.length - 1) const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

/// Kartu kecil untuk 1 lokasi donor darah (foto diambil dari asset lokal,
/// lihat _DataLokasi.fotoAsset).
class _KartuLokasiItem extends StatelessWidget {
  final _DataLokasi data;
  const _KartuLokasiItem({required this.data});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    debugPrint('Render kartu lokasi: ${data.nama} | fotoUrl=${data.fotoUrl} | fotoAsset=${data.fotoAsset}');
    return Container(
      width: double.infinity, // kartu selalu selebar induknya, tidak ikut ukuran konten
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
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
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            debugPrint('Gagal load foto lokasi: ${data.fotoUrl} -> $error');
                            return Container(
                              width: 72,
                              height: 72,
                              color: AppColors.background,
                              child: const Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary),
                            );
                          },
                        )
                      : data.fotoAsset != null
                          ? Image.asset(
                              data.fotoAsset!,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 72,
                              height: 72,
                              color: AppColors.background,
                              child: const Icon(Icons.local_hospital_outlined, color: AppColors.textSecondary),
                            ),
                ),
                const SizedBox(width: 12),
                // Lebar teks DIBUAT TETAP (tidak ikut panjang nama rumah sakit),
                // supaya lebar total blok konten selalu sama di semua kartu.
                // Ini kuncinya supaya hasil "center" tetap sejajar antar kartu.
                SizedBox(
                  width: 190,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(data.nama, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Flexible(
                            child: Text(
                              data.alamat,
                              style: AppTextStyles.caption,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(s.openDonorStatus, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      if (data.tanggalPelaksanaan != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today_outlined, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 2),
                            Text(data.tanggalPelaksanaan!, style: AppTextStyles.caption),
                          ],
                        ),
                      ],
                      if (data.jamMulai != null && data.jamSelesai != null) ...[
                        const SizedBox(height: 2),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                            const SizedBox(width: 2),
                            Text(
                              data.jamMulai != null && data.jamSelesai != null && data.sisaKuota != null
                                  ? s.scheduleQuota(data.jamMulai!, data.jamSelesai!, data.sisaKuota!)
                                  : '${data.jamMulai} - ${data.jamSelesai}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 274, // sama dengan lebar Row foto+teks di atas (72+12+190)
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(36),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                  // TODO: navigasi ke halaman Detail Lokasi
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(s.viewLocationDetails),
                    const SizedBox(width: 6),
                    const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}

/// Kartu shortcut ke Chatbot Reza / Admin CS.
class _KartuChat extends StatefulWidget {
  final String judul;
  final String subjudul;
  final String? iconAssetPath; // null = tanpa avatar kiri (mis. Reza Chatbot)
  final VoidCallback onTapPanah; // panah kanan atas = redirect biasa
  final ValueChanged<String> onKirimPesan; // tombol search = redirect + bawa teks

  const _KartuChat({
    required this.judul,
    required this.subjudul,
    this.iconAssetPath,
    required this.onTapPanah,
    required this.onKirimPesan,
  });

  @override
  State<_KartuChat> createState() => _KartuChatState();
}

class _KartuChatState extends State<_KartuChat> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _kirim() {
    widget.onKirimPesan(_controller.text);
  }

  void _hapusDanTutupKeyboard() {
    _controller.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (widget.iconAssetPath != null) ...[
                CircleAvatar(
                  backgroundColor: AppColors.background,
                  backgroundImage: AssetImage(widget.iconAssetPath!),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.judul, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
                    Text(widget.subjudul, style: AppTextStyles.caption),
                  ],
                ),
              ),
              GestureDetector(
                onTap: widget.onTapPanah,
                child: const Icon(Icons.arrow_forward, size: 18),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(999), // rounded penuh
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: AppTextStyles.body,
                          decoration: InputDecoration(
                            hintText: s.writeQuestionHint,
                            filled: false,
                            isDense: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                          onSubmitted: (_) => _kirim(),
                        ),
                      ),
                      GestureDetector(
                        onTap: _hapusDanTutupKeyboard,
                        child: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                      ),
                    ],
                  ),

                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: _kirim,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary),
                  child: const Icon(Icons.search, size: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Modal Notifikasi (N-001), muncul sebagai popup di atas Beranda.
class _NotifikasiModal extends StatefulWidget {
  const _NotifikasiModal();

  @override
  State<_NotifikasiModal> createState() => _NotifikasiModalState();
}

class _NotifikasiModalState extends State<_NotifikasiModal> {
  final NotifikasiService _service = NotifikasiService();
  List<DataNotifikasi> _daftar = [];
  bool _sedangMuat = true;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    try {
      final hasil = await _service.ambilNotifikasi();
      if (mounted) setState(() { _daftar = hasil; _sedangMuat = false; });
    } catch (_) {
      if (mounted) setState(() => _sedangMuat = false);
    }
  }

  Future<void> _tandaiBaca(DataNotifikasi item) async {
    try {
      await _service.tandaiBaca(item.idNotifikasi);
      if (mounted) {
        setState(() => _daftar.removeWhere((n) => n.idNotifikasi == item.idNotifikasi));
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(s.notificationsTitle, style: AppTextStyles.subheading, textAlign: TextAlign.center),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (_sedangMuat)
              const Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              )
            else if (_daftar.isEmpty)
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text(s.noNotifications,
                    style: const TextStyle(color: AppColors.textSecondary)),
              )
            else
              ..._daftar.map((n) => _kartuNotifikasi(n)),
          ],
        ),
      ),
    );
  }

  Widget _kartuNotifikasi(DataNotifikasi item) {
    final String assetPath = switch (item.tipe) {
      'success' => 'assets/icons/notifikasi/success.png',
      'warning' => 'assets/icons/notifikasi/danger.png',
      _ => 'assets/icons/notifikasi/info.png',
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(assetPath, width: 28, height: 28),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.pesan, style: AppTextStyles.body),
                const SizedBox(height: 2),
                Text(item.waktu, style: AppTextStyles.caption),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _tandaiBaca(item),
            child: const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}