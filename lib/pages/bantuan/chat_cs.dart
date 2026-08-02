// ignore_for_file: unnecessary_underscores

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
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(s.contactSupportTitle, style: AppTextStyles.subheading),
        titleSpacing: 0,
      ),
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
                    const SizedBox(height: 16),

                    Text(s.csGreetingName, style: AppTextStyles.heading),
                    Text(s.csGreetingTeam, style: AppTextStyles.heading),
                    const SizedBox(height: 8),
                    Text(
                      s.csTopicPrompt,
                      style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _TombolTopik(label: s.topicDonorIssue, onTap: () => _pilihTopik(s.topicDonorIssue)),
                          const SizedBox(height: 12),
                          _TombolTopik(label: s.topicAccountIssue, onTap: () => _pilihTopik(s.topicAccountIssue)),
                          const SizedBox(height: 12),
                          _TombolTopik(label: s.topicLocationInfo, onTap: () => _pilihTopik(s.topicLocationInfo)),
                          const SizedBox(height: 12),
                          _TombolTopik(label: s.topicOther, onTap: () => _pilihTopik(s.topicOther)),
                        ],
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
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL, 8, AppDimens.paddingL, 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesanController,
                        decoration: InputDecoration(
                          hintText: s.csMessageHint,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _kirimPesan,
                      child: const Icon(Icons.send, color: AppColors.textSecondary),
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

class _TombolTopik extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TombolTopik({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        alignment: Alignment.centerLeft,
        minimumSize: const Size(0, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      onPressed: onTap,
      child: Text(label, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
