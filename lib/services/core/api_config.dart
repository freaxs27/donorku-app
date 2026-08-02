/// Konfigurasi terpusat untuk semua panggilan API ke backend Donorku.
///
/// Override saat run/build lewat `--dart-define`:
/// ```bash
/// flutter run \
///   --dart-define=API_BASE_URL=https://staging.example/api/mobile \
///   --dart-define=MEDIA_BASE_URL=https://staging.example
/// ```
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://donorku.site/api/mobile',
  );

  /// Base URL buat file/gambar yang path-nya dikirim RELATIF oleh backend
  /// (mis. "foto_lokasi": "/uploads/lokasi/xxx.jpg").
  static const String mediaBaseUrl = String.fromEnvironment(
    'MEDIA_BASE_URL',
    defaultValue: 'https://donorku.site',
  );

  /// Gabungkan path relatif dari backend jadi URL lengkap untuk Image.network().
  /// Return null kalau path null/kosong.
  static String? urlMedia(String? pathRelatif) {
    if (pathRelatif == null || pathRelatif.isEmpty) return null;
    if (pathRelatif.startsWith('http')) return pathRelatif;
    return '$mediaBaseUrl$pathRelatif';
  }
}
