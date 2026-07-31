import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

// (C-001).
class RezaChatbotPage extends StatefulWidget {
  const RezaChatbotPage({super.key});

  @override
  State<RezaChatbotPage> createState() => _RezaChatbotPageState();
}

class _RezaChatbotPageState extends State<RezaChatbotPage> {
  final TextEditingController _pesanController = TextEditingController();

  @override
  void dispose() {
    _pesanController.dispose();
    super.dispose();
  }

  void _pilihSaran(String teks) {
    setState(() => _pesanController.text = teks);
  }

  void _kirimPesan() {
    if (_pesanController.text.trim().isEmpty) return;
    debugPrint('Pesan ke Reza: ${_pesanController.text}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: const BackButton(color: AppColors.textPrimary),
        title: const Text('Reza Chatbot', style: AppTextStyles.subheading),
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
                    const SizedBox(height: 40),
                    Text(
                      'Halo, User',
                      style: AppTextStyles.body.copyWith(fontSize: 16, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Reza di sini akan',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const Text(
                      'membantumu',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _TombolSaran(label: 'Lorem Ipsum', onTap: () => _pilihSaran('Lorem Ipsum')),
                            const SizedBox(height: 12),
                            _TombolSaran(label: 'Lorem Ipsum', onTap: () => _pilihSaran('Lorem Ipsum')),
                            const SizedBox(height: 12),
                            _TombolSaran(label: 'Lorem Ipsum', onTap: () => _pilihSaran('Lorem Ipsum')),
                            const SizedBox(height: 12),
                            _TombolSaran(label: 'Lorem Ipsum', onTap: () => _pilihSaran('Lorem Ipsum')),
                          ],
                        ),
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
                        decoration: const InputDecoration(
                          hintText: 'Tanya Reza Chatbot..',
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

class _TombolSaran extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _TombolSaran({required this.label, required this.onTap});

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