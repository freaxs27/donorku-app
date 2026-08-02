import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/locale/app_strings.dart';

// (CA-001).
class ChatCsPage extends StatefulWidget {
  final String? pesanAwal;

  const ChatCsPage({super.key, this.pesanAwal});

  @override
  State<ChatCsPage> createState() => _ChatCsPageState();
}

class _ChatCsPageState extends State<ChatCsPage> {
  late final TextEditingController _pesanController =
      TextEditingController(text: widget.pesanAwal ?? '');

  @override
  void dispose() {
    _pesanController.dispose();
    super.dispose();
  }

  void _pilihTopik(String topik) {
    debugPrint('Topik dipilih: $topik');
  }

  void _kirimPesan() {
    if (_pesanController.text.trim().isEmpty) return;
    debugPrint('Pesan dikirim: ${_pesanController.text}');
    _pesanController.clear();
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
                padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // Foto staf dukungan (Revan)
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimens.radiusM),
                        child: Image.asset(
                          'assets/images/cs.png',
                          width: 187,
                          height: 198,
                          fit: BoxFit.cover,
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
                  ],
                ),
              ),
            ),

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
