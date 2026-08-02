import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/locale/app_strings.dart';

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
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: BackButton(color: AppColors.of(context).textPrimary),
        title: Text(s.rezaChatbotTitle, style: AppTextStyles.subheading(context)),
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
                      s.rezaGreeting,
                      style: AppTextStyles.body(context).copyWith(fontSize: 16, color: AppColors.of(context).textSecondary),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      s.rezaIntroLine1,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.of(context).textPrimary),
                    ),
                    Text(
                      s.rezaIntroLine2,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.of(context).textPrimary),
                    ),
                    const SizedBox(height: 20),

                    Align(
                      alignment: Alignment.centerLeft,
                      child: IntrinsicWidth(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _TombolSaran(label: s.rezaSuggestionSyarat, onTap: () => _pilihSaran(s.rezaSuggestionSyarat)),
                            const SizedBox(height: 12),
                            _TombolSaran(label: s.rezaSuggestionJarak, onTap: () => _pilihSaran(s.rezaSuggestionJarak)),
                            const SizedBox(height: 12),
                            _TombolSaran(label: s.rezaSuggestionCaraDaftar, onTap: () => _pilihSaran(s.rezaSuggestionCaraDaftar)),
                            const SizedBox(height: 12),
                            _TombolSaran(label: s.rezaSuggestionLokasi, onTap: () => _pilihSaran(s.rezaSuggestionLokasi)),
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
                  color: AppColors.of(context).surface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusL),
                  border: Border.all(color: AppColors.of(context).border),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _pesanController,
                        decoration: InputDecoration(
                          hintText: s.rezaInputHint,
                          filled: false,
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: _kirimPesan,
                      child: Icon(Icons.send, color: AppColors.of(context).textSecondary),
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
      child: Text(label, style: AppTextStyles.body(context).copyWith(fontWeight: FontWeight.bold)),
    );
  }
}
