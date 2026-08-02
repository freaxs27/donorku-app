import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/cs/cs_service.dart';
import '../../services/core/api_exception.dart';

class ChatCsPage extends StatefulWidget {
  final String? pesanAwal;
  const ChatCsPage({super.key, this.pesanAwal});

  @override
  State<ChatCsPage> createState() => _ChatCsPageState();
}

class _ChatCsPageState extends State<ChatCsPage> {
  final TextEditingController _pesanController = TextEditingController();
  final CsService _csService = CsService();
  final FocusNode _focusNode = FocusNode();

  String? _topikTerpilih;
  bool _sedangKirim = false;

  static const List<String> _daftarTopik = [
    'Masalah Donor',
    'Masalah Akun',
    'Informasi Lokasi',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pesanAwal != null) {
      _pesanController.text = widget.pesanAwal!;
    }
  }

  @override
  void dispose() {
    _pesanController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _kirimPesan() async {
    final topik = _topikTerpilih;
    final pesan = _pesanController.text.trim();

    if (topik == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih topik terlebih dahulu')),
      );
      return;
    }
    if (pesan.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tulis pesan terlebih dahulu')),
      );
      return;
    }

    setState(() => _sedangKirim = true);
    try {
      await _csService.kirimPesan(topik: topik, pesan: pesan);
      if (mounted) {
        _pesanController.clear();
        setState(() => _topikTerpilih = null);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pesan berhasil dikirim ke support')),
        );
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message)));
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim pesan, coba lagi.')),
        );
      }
    } finally {
      if (mounted) setState(() => _sedangKirim = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Header
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: const Icon(Icons.arrow_back,
                              size: 24, color: AppColors.textPrimary),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Hubungi Staf Dukungan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Foto Revan
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/cs.png',
                          width: 180,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD8D8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(Icons.person,
                                size: 80, color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Judul
                    const Text(
                      'Halo! Saya Revan\ndari Tim Dukungan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Pilih topik dibawah ini agar saya\nbisa membantumu lebih cepat',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol topik — lebar mengikuti teks terpanjang
                    ..._daftarTopik.map((topik) {
                      final terpilih = _topikTerpilih == topik;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _topikTerpilih = topik),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              minWidth: 160, // lebar minimum
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                color: terpilih
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: terpilih
                                      ? AppColors.primary
                                      : Colors.black87,
                                  width: 1.2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.06),
                                    blurRadius: 4,
                                    offset: Offset.zero,
                                  ),
                                ],
                              ),
                              child: Text(
                                topik,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: terpilih
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Field chat di bawah — sejajar dengan topik, outline hitam
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: TextField(
                controller: _pesanController,
                focusNode: _focusNode,
                style: const TextStyle(
                    fontSize: 14, color: AppColors.textPrimary),
                decoration: InputDecoration(
                  hintText: 'Ketik pesan untuk admin disini...',
                  hintStyle: const TextStyle(
                      fontSize: 14, color: AppColors.textHint),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 12),
                  suffixIcon: GestureDetector(
                    onTap: _sedangKirim ? null : _kirimPesan,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: _sedangKirim
                          ? const SizedBox(
                              width: 16, height: 16,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.textSecondary),
                            )
                          : Image.asset(
                              'assets/icons/bantuan/send.png',
                              width: 20,
                              height: 20,
                            ),
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black87, width: 1.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black87, width: 1.2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black87, width: 1.5),
                  ),
                ),
                onSubmitted: (_) => _kirimPesan(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}