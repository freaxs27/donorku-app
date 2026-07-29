import 'package:flutter/material.dart';

/// Kumpulan warna yang dipakai di seluruh aplikasi Donorku.
/// Diambil berdasarkan palet di desain: L-001, D-001, B-001, P-001.
class AppColors {
  AppColors._(); // tidak bisa di-instantiate

  // Warna utama (merah khas "darah/donor")
  static const Color primary = Color(0xFFEC2727);
  static const Color primaryDark = Color(0xFFC62828);

  // Background & permukaan
  static const Color background = Color(0xFFF2F2F2);
  static const Color surface = Color(0xFFFFFFFF);

  // Teks
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);

  // Border / garis input
  static const Color border = Color(0xFFD9D9D9);

  // Status (dipakai nanti di modal feedback / notifikasi)
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFD32F2F);
}

/// Kumpulan text style yang konsisten dipakai di seluruh halaman.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto'; // font default dulu,
  // nanti bisa diganti kalau ada font khusus dari desainer (mis. Poppins/Inter)

  static const TextStyle heading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle subheading = TextStyle(
    fontFamily: fontFamily,
    fontSize: 17,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// Ukuran radius & spacing standar, biar konsisten di semua halaman
/// (card, tombol, input field semuanya pakai radius yang sama).
class AppDimens {
  AppDimens._();

  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 20;

  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
}

/// ThemeData utama yang dipasang di MaterialApp (lihat main.dart).
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.subheading,
      ),

      // Style default untuk semua ElevatedButton (tombol solid merah)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
          elevation: 0,
        ),
      ),

      // Style default untuk OutlinedButton (tombol outline putih, mis. "Reset")
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.textPrimary,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.textPrimary),
          side: const BorderSide(color: Colors.black, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      ),

      // Style default untuk semua TextField (input email, password, dst.)
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textHint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: const BorderSide(color: Colors.black, width: 1.5),
        ),
      ),
    );
  }
}