import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../bantuan/reza_chatbot_page.dart';
import '../bantuan/chat_cs.dart';

// (D-001 / B-001).
class BerandaPage extends StatelessWidget {
  const BerandaPage({super.key});

  void _bukaNotifikasi(BuildContext context) async {
    await showDialog(
      context: context,
      barrierDismissible: true, 
      builder: (context) => const _NotifikasiModal(),
    );
    if (context.mounted) FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text('Halo, Kaka', style: AppTextStyles.heading),
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

            _KartuMulaiDonor(),
            const SizedBox(height: 20),

            const _KartuAndaSudahDonor(),
            const SizedBox(height: 20),

            const _KartuLokasiTersedia(
              daftarLokasi: [
                _DataLokasi(
                  nama: 'Rumah Sakit Pasundan',
                  alamat: 'Lebakgede, Coblong',
                  fotoAsset: 'assets/images/lokasi/rs-pasundan.jpg',
                ),
                _DataLokasi(
                  nama: 'Rumah Sakit Santo Boromeus',
                  alamat: 'Lebakgede, Coblong',
                  fotoAsset: 'assets/images/lokasi/rs-santo.jpg',
                ),
              ],
            ),
            const SizedBox(height: 20),

            _KartuChat(
              judul: 'Bicara Dengan Reza Chatbot',
              subjudul: 'Silahkan bertanya kepada Reza seputar donor darah',
              iconAssetPath: null,
              onTapPanah: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RezaChatbotPage()),
              ),
              onKirimPesan: (pesan) => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RezaChatbotPage()),
              ),
            ),
            const SizedBox(height: 12),
            _KartuChat(
              judul: 'Bicara Dengan Admin',
              subjudul: 'Terhubung langsung dengan staf dukungan',
              iconAssetPath: 'assets/icons/bantuan/admin.png',
              onTapPanah: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ChatCsPage()),
              ),
              onKirimPesan: (pesan) => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ChatCsPage(pesanAwal: pesan)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

class _KartuMulaiDonor extends StatelessWidget {
  const _KartuMulaiDonor();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusM),
      child: Container(
        width: double.infinity, 
        color: AppColors.surface,
        child: Stack(
          children: [
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
                  const SizedBox(
                    width: 190,
                    child: Text('Mulai Donorkan Darahmu', style: AppTextStyles.subheading),
                  ),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: 190,
                    child: Text(
                      'Donorkan di posko donor terdekat untuk membantu orang yang membutuhkan',
                      style: AppTextStyles.caption,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(minimumSize: const Size(140, 40)),
                    onPressed: () {
                    },
                    child: const Text('Daftar Donor'),
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

class _KartuAndaSudahDonor extends StatelessWidget {
  const _KartuAndaSudahDonor();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _JudulSeksi(judul: 'Anda Sudah Donor'),
          const SizedBox(height: 12),

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
                      const Text('8', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text('Total Donasi', style: AppTextStyles.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 40, child: VerticalDivider(color: AppColors.border)),
                Expanded(
                  child: Column(
                    children: [
                      const Text('3600', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
                      Text('ml Darah', style: AppTextStyles.caption),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 26),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Dapat Donor Kembali', style: AppTextStyles.body),
                    const SizedBox(height: 2),
                    const Text(
                      '20 Januari 2026',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DataLokasi {
  final String nama;
  final String alamat;
  final String fotoAsset;
  const _DataLokasi({required this.nama, required this.alamat, required this.fotoAsset});
}

class _KartuLokasiTersedia extends StatelessWidget {
  final List<_DataLokasi> daftarLokasi;
  const _KartuLokasiTersedia({required this.daftarLokasi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _JudulSeksi(judul: 'Lokasi Tersedia Donor Darah'),
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

class _KartuLokasiItem extends StatelessWidget {
  final _DataLokasi data;
  const _KartuLokasiItem({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, 
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
                  child: Image.asset(
                    data.fotoAsset,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
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
                          Text(data.alamat, style: AppTextStyles.caption),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text('Open Donor Darah', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: 274, 
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(36),
                  shape: const StadiumBorder(),
                ),
                onPressed: () {
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('Cek Detail Lokasi'),
                    SizedBox(width: 6),
                    Icon(Icons.arrow_forward, size: 16, color: Colors.white),
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

class _KartuChat extends StatefulWidget {
  final String judul;
  final String subjudul;
  final String? iconAssetPath; 
  final VoidCallback onTapPanah; 
  final ValueChanged<String> onKirimPesan; 

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
                    borderRadius: BorderRadius.circular(999), 
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: AppTextStyles.body,
                          decoration: const InputDecoration(
                            hintText: 'Tulis Pertanyaanmu',
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

class _NotifikasiModal extends StatelessWidget {
  const _NotifikasiModal();

  static const List<_ItemNotifikasi> _daftarNotifikasi = [
    _ItemNotifikasi(
      tipe: _TipeNotifikasi.info,
      pesan: 'Kaka, Jadwal donor anda akan dimulai besok',
      waktu: '1 Jam yang lalu',
    ),
    _ItemNotifikasi(
      tipe: _TipeNotifikasi.info,
      pesan: 'Hari ini anda bisa mendonorkan darah anda di Lokasi [...]',
      waktu: '1 Jam yang lalu',
    ),
    _ItemNotifikasi(
      tipe: _TipeNotifikasi.sukses,
      pesan: 'Anda telah daftar donor di Lokasi [...] untuk tanggal [...]',
      waktu: '6 Hari yang lalu',
    ),
    _ItemNotifikasi(
      tipe: _TipeNotifikasi.peringatan,
      pesan: 'Kaka, kamu belum menyalakan notifikasi anda',
      waktu: '1 Jam yang lalu',
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
                const Expanded(
                  child: Text('Notifikasi', style: AppTextStyles.subheading, textAlign: TextAlign.center),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._daftarNotifikasi.map((n) => _kartuNotifikasi(n)),
          ],
        ),
      ),
    );
  }

  Widget _kartuNotifikasi(_ItemNotifikasi item) {
    late final String assetPath;
    switch (item.tipe) {
      case _TipeNotifikasi.info:
        assetPath = 'assets/icons/notifikasi/info.png';
        break;
      case _TipeNotifikasi.sukses:
        assetPath = 'assets/icons/notifikasi/success.png';
        break;
      case _TipeNotifikasi.peringatan:
        assetPath = 'assets/icons/notifikasi/danger.png';
        break;
    }

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
          const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

enum _TipeNotifikasi { info, sukses, peringatan }

class _ItemNotifikasi {
  final _TipeNotifikasi tipe;
  final String pesan;
  final String waktu;

  const _ItemNotifikasi({required this.tipe, required this.pesan, required this.waktu});
}