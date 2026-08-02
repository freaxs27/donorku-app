import 'package:flutter/material.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../widgets/main_layout.dart';

// (D-005).
class DonorSuksesPage extends StatefulWidget {
  const DonorSuksesPage({super.key});

  @override
  State<DonorSuksesPage> createState() => _DonorSuksesPageState();
}

class _DonorSuksesPageState extends State<DonorSuksesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bukaFeedback());
  }

  void _bukaFeedback() {
    showDialog(
      context: context,
      useRootNavigator: false,
      barrierDismissible: true, 
      builder: (context) => const _ModalFeedback(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: const Icon(Icons.check, color: AppColors.primary, size: 40),
              ),
              const SizedBox(height: 24),
              Text(
                s.registrationSuccess,
                style: AppTextStyles.subheading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModalFeedback extends StatefulWidget {
  const _ModalFeedback();

  @override
  State<_ModalFeedback> createState() => _ModalFeedbackState();
}

class _ModalFeedbackState extends State<_ModalFeedback> {
  int _rating = 3; 
  final TextEditingController _saranController = TextEditingController();

  @override
  void dispose() {
    _saranController.dispose();
    super.dispose();
  }

  void _kirimFeedback() {
    Navigator.of(context).pop(); 
    MainLayoutScope.of(context)?.pindahTab(0); 
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Dialog(
      backgroundColor: AppColors.background,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimens.radiusL)),
      child: Padding(
        padding: const EdgeInsets.all(AppDimens.paddingM),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(s.feedbackTitle, textAlign: TextAlign.center, style: AppTextStyles.subheading),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.close, size: 20),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(s.experienceQuestion, style: AppTextStyles.body),
            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(5, (i) {
                  final terisi = i < _rating;
                  return GestureDetector(
                    onTap: () => setState(() => _rating = i + 1),
                    child: Icon(
                      terisi ? Icons.star : Icons.star_border,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 16),

            Text(s.feedbackHintLabel, style: AppTextStyles.body),
            const SizedBox(height: 10),

            TextField(
              controller: _saranController,
              maxLines: 4,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _kirimFeedback,
              child: Text(s.sendFeedbackButton),
            ),
          ],
        ),
      ),
    );
  }
}