import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../core/locale/app_strings.dart';
import '../login_page.dart';
import '../../../widgets/theme_sync.dart';

// (LP-004).
class ResetSuksesPage extends StatelessWidget {
  const ResetSuksesPage({super.key});

  void _kembaliKeLogin(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      AppPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 100),

              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                  border: Border.all(color: AppColors.primary, width: 1.5),
                ),
                child: const Icon(
                  Icons.check,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                s.passwordResetSuccess,
                style: AppTextStyles.subheading(context),
              ),
              const SizedBox(height: 32),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _kembaliKeLogin(context),
                  child: Text(s.backToLogin),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
