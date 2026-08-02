import 'package:flutter/material.dart';

/// Palet warna yang terikat ke [ThemeData.extensions].
/// Ambil lewat [AppColors.of] agar widget otomatis rebuild saat tema diganti.
@immutable
class DonorkuColors extends ThemeExtension<DonorkuColors> {
  const DonorkuColors({
    required this.background,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
    required this.textHint,
    required this.border,
    required this.isDark,
  });

  final Color background;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;
  final Color textHint;
  final Color border;
  final bool isDark;

  static const light = DonorkuColors(
    background: Color(0xFFF2F2F2),
    surface: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF757575),
    textHint: Color(0xFFBDBDBD),
    border: Color(0xFFD9D9D9),
    isDark: false,
  );

  static const dark = DonorkuColors(
    background: Color(0xFF121212),
    surface: Color(0xFF1E1E1E),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFB0B0B0),
    textHint: Color(0xFF757575),
    border: Color(0xFF3A3A3A),
    isDark: true,
  );

  @override
  DonorkuColors copyWith({
    Color? background,
    Color? surface,
    Color? textPrimary,
    Color? textSecondary,
    Color? textHint,
    Color? border,
    bool? isDark,
  }) {
    return DonorkuColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textHint: textHint ?? this.textHint,
      border: border ?? this.border,
      isDark: isDark ?? this.isDark,
    );
  }

  @override
  DonorkuColors lerp(ThemeExtension<DonorkuColors>? other, double t) {
    if (other is! DonorkuColors) return this;
    return t < 0.5 ? this : other;
  }
}

/// Akses warna Donorku.
///
/// Warna yang berubah antar tema: [AppColors.of] `(context).background` dll.
/// Warna tetap: [AppColors.primary], [success], dst.
class AppColors {
  AppColors._();

  static const Color primary = Color(0xFFEC2727);
  static const Color primaryDark = Color(0xFFC62828);
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFD32F2F);

  /// Terikat ke Theme — widget yang memanggil ini rebuild otomatis saat tema diganti.
  static DonorkuColors of(BuildContext context) {
    return Theme.of(context).extension<DonorkuColors>() ?? DonorkuColors.light;
  }
}

/// Text style — butuh [BuildContext] supaya warna ikut tema.
class AppTextStyles {
  AppTextStyles._();

  static const String fontFamily = 'Roboto';

  static TextStyle heading(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.of(context).textPrimary,
      );

  static TextStyle subheading(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: AppColors.of(context).textPrimary,
      );

  static TextStyle body(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        fontWeight: FontWeight.normal,
        color: AppColors.of(context).textPrimary,
      );

  static TextStyle caption(BuildContext context) => TextStyle(
        fontFamily: fontFamily,
        fontSize: 12,
        fontWeight: FontWeight.normal,
        color: AppColors.of(context).textSecondary,
      );

  static const TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

class AppDimens {
  AppDimens._();

  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 20;

  static const double paddingS = 8;
  static const double paddingM = 16;
  static const double paddingL = 24;
}

/// ThemeData terang & gelap untuk [MaterialApp].
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => _bangun(Brightness.light);

  static ThemeData get darkTheme => _bangun(Brightness.dark);

  static ThemeData _bangun(Brightness brightness) {
    final gelap = brightness == Brightness.dark;
    final colors = gelap ? DonorkuColors.dark : DonorkuColors.light;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      extensions: <ThemeExtension<dynamic>>[colors],
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: brightness,
        primary: AppColors.primary,
        surface: colors.surface,
      ),
      fontFamily: AppTextStyles.fontFamily,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.textPrimary,
          minimumSize: const Size.fromHeight(52),
          textStyle: AppTextStyles.button.copyWith(color: colors.textPrimary),
          side: BorderSide(
            color: gelap ? colors.border : Colors.black,
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: TextStyle(
          fontFamily: AppTextStyles.fontFamily,
          fontSize: 14,
          color: colors.textHint,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimens.paddingM,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: gelap ? colors.border : Colors.black,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: gelap ? colors.border : Colors.black,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimens.radiusM),
          borderSide: BorderSide(
            color: gelap ? AppColors.primary : Colors.black,
            width: 1.5,
          ),
        ),
      ),
      dividerColor: colors.border,
      cardColor: colors.surface,
    );
  }
}
