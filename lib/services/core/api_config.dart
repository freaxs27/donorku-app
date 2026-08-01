/// Konfigurasi terpusat untuk semua panggilan API ke backend Donorku.
/// Kalau nanti base URL berubah (misal pindah ke backend lokal buat
/// testing), cukup ubah di 1 tempat ini saja.
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = 'https://donorku.site/api/mobile';

  /// Base URL buat file/gambar yang path-nya dikirim RELATIF oleh backend
  /// (mis. "foto_lokasi": "/uploads/lokasi/xxx.jpg"). Beda dari [baseUrl]
  /// karena file bukan di bawah /api/mobile, tapi langsung di root domain.
  static const String mediaBaseUrl = 'https://donorku.site';

  /// Helper: gabungkan path relatif dari backend jadi URL lengkap yang
  /// bisa langsung dipakai Image.network(). Return null kalau path-nya
  /// null/kosong (biar caller gampang fallback ke placeholder).
  static String? urlMedia(String? pathRelatif) {
    if (pathRelatif == null || pathRelatif.isEmpty) return null;
    if (pathRelatif.startsWith('http')) return pathRelatif; // sudah URL lengkap
    return '$mediaBaseUrl$pathRelatif';
  }

  // Contoh nanti dipakai: '${ApiConfig.baseUrl}/auth/register'
}