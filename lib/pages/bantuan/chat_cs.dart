// ignore_for_file: unnecessary_underscores

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/locale/app_strings.dart';
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

  void _pilihTopik(String topik) {
    setState(() => _topikTerpilih = topik);
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
    final colors = AppColors.of(context);
    return Scaffold(
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
                          child: Icon(Icons.arrow_back,
                              size: 24, color: colors.textPrimary),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          s.contactSupportTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: colors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Foto CS
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

                    Text(s.csGreetingName, style: AppTextStyles.heading(context)),
                    Text(s.csGreetingTeam, style: AppTextStyles.heading(context)),
                    const SizedBox(height: 8),
                    Text(
                      s.csTopicPrompt,
                      style: AppTextStyles.body(context)
                          .copyWith(color: colors.textSecondary),
                    ),
                    const SizedBox(height: 20),

                    // Tombol topik
                    IntrinsicWidth(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: _daftarTopik.map((topik) {
                          final terpilih = _topikTerpilih == topik;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _TombolTopik(
                              label: topik,
                              terpilih: terpilih,
                              onTap: () => _pilihTopik(topik),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),

            // Field chat di bawah
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppDimens.paddingL, 8, AppDimens.paddingL, 16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                  border: Border.all(color: colors.border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesanController,
                        focusNode: _focusNode,
                        decoration: const InputDecoration(
                          hintText: 'Ketik pesan untuk admin disini...',
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                        onSubmitted: (_) => _kirimPesan(),
                      ),
                    ),
                    GestureDetector(
                      onTap: _sedangKirim ? null : _kirimPesan,
                      child: _sedangKirim
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: colors.textSecondary),
                            )
                          : Image.asset(
                              'assets/icons/Send.png',
                              width: 24,
                              height: 24,
                              errorBuilder: (_, __, ___) => Icon(Icons.send,
                                  color: colors.textSecondary),
                            ),
                    ),
                  ],
                ),
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
  final bool terpilih;
  final VoidCallback onTap;

  const _TombolTopik({
    required this.label,
    required this.terpilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: terpilih ? AppColors.primary : colors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: terpilih ? AppColors.primary : colors.border,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: terpilih ? Colors.white : colors.textPrimary,
          ),
        ),
      ),
    );
  }
}
