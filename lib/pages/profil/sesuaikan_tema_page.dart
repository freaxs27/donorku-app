import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../core/theme/app_tema.dart';
import '../../core/locale/app_strings.dart';

/// Halaman Sesuaikan Tema — gaya kartu sama dengan Pilih Bahasa / Pengaturan.
class SesuaikanTemaPage extends StatelessWidget {
  const SesuaikanTemaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final s = AppStrings.of(context);
        final terpilih = ThemeController.instance.tema;

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
                          s.judulSesuaikanTema,
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
                          s.deskripsiSesuaikanTema,
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
                              for (int i = 0; i < AppTema.values.length; i++) ...[
                                if (i > 0)
                                  Divider(
                                    height: 1,
                                    color: AppColors.of(context).border,
                                    indent: 56,
                                  ),
                                _BarisTema(
                                  tema: AppTema.values[i],
                                  judul: s.labelTema(AppTema.values[i]),
                                  deskripsi: s.deskripsiTema(AppTema.values[i]),
                                  terpilih: terpilih == AppTema.values[i],
                                  onTap: () =>
                                      _pilih(context, AppTema.values[i]),
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
      },
    );
  }

  Future<void> _pilih(BuildContext context, AppTema tema) async {
    await ThemeController.instance.setTema(tema);
    if (!context.mounted) return;
    final s = AppStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(s.temaBerhasilDiubah),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _BarisTema extends StatelessWidget {
  final AppTema tema;
  final String judul;
  final String deskripsi;
  final bool terpilih;
  final VoidCallback onTap;

  const _BarisTema({
    required this.tema,
    required this.judul,
    required this.deskripsi,
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
              tema.ikon,
              size: 24,
              color: terpilih ? AppColors.primary : AppColors.of(context).textPrimary,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          terpilih ? FontWeight.w600 : FontWeight.normal,
                      color: AppColors.of(context).textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    deskripsi,
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
