import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/locale/app_bahasa.dart';
import '../../core/locale/app_strings.dart';

/// Halaman Pilih Bahasa — gaya kartu sama dengan Pengaturan (P-002).
class PilihBahasaPage extends StatelessWidget {
  const PilihBahasaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    final terpilih = LocaleController.instance.bahasa;

    return Scaffold(
      backgroundColor: AppColors.of(context).background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: 28,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      s.judulPilihBahasa,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.of(context).textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 28),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      s.deskripsiPilihBahasa,
                      style: AppTextStyles.body(context).copyWith(
                        color: AppColors.of(context).textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.of(context).surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 4,
                            offset: Offset.zero,
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (int i = 0;
                              i < AppBahasa.values.length;
                              i++) ...[
                            if (i > 0)
                              Divider(
                                height: 1,
                                color: AppColors.of(context).border,
                                indent: 56,
                              ),
                            _BarisBahasa(
                              bahasa: AppBahasa.values[i],
                              terpilih: terpilih == AppBahasa.values[i],
                              onTap: () => _pilih(context, AppBahasa.values[i]),
                            ),
                          ],
                        ],
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

  Future<void> _pilih(BuildContext context, AppBahasa bahasa) async {
    await LocaleController.instance.setBahasa(bahasa);
    if (!context.mounted) return;
    // Pakai bahasa yang baru dipilih — Localizations mungkin belum rebuild di frame ini.
    final s = AppStrings.dariBahasa(bahasa);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s.bahasaBerhasilDiubah),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _BarisBahasa extends StatelessWidget {
  final AppBahasa bahasa;
  final bool terpilih;
  final VoidCallback onTap;

  const _BarisBahasa({
    required this.bahasa,
    required this.terpilih,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              Icons.language,
              size: 24,
              color: terpilih ? AppColors.primary : AppColors.of(context).textPrimary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bahasa.namaTampil,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          terpilih ? FontWeight.w600 : FontWeight.normal,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    bahasa.deskripsi,
                    style: AppTextStyles.caption(context),
                  ),
                ],
              ),
            ),
            if (terpilih)
              const Icon(
                Icons.check_circle,
                size: 22,
                color: AppColors.primary,
              )
            else
              Icon(
                Icons.circle_outlined,
                size: 22,
                color: AppColors.of(context).border,
              ),
          ],
        ),
      ),
    );
  }
}
