import '../core/api_client.dart';

/// Service untuk submit pendaftaran donor (dipanggil dari D-004 saat user
/// menekan "Daftar Donor"). Sesuai kontrak backend:
/// POST /api/mobile/pendaftaran
/// Body: { id_jadwal, jawaban: { 13 pertanyaan kuesioner } }
///
/// Token Authorization sudah otomatis ditempel oleh `ApiClient` (diambil
/// dari `SessionService`) -- tidak perlu ambil/cek token manual di sini.
///
/// Field lain (id_pendonor, id_admin, nomor_antrian, status_pendaftaran,
/// tanggal_daftar) SENGAJA TIDAK dikirim dari app -- semua ditentukan
/// otomatis oleh backend dari token & konteks jadwal, supaya tidak bisa
/// disuntik client (lihat catatan di route.ts backend).
class PendaftaranService {
  /// [jawaban] wajib berisi 13 key sesuai nama kolom di
  /// `KuesionerKesehatan`, contoh:
  /// {
  ///   "demam_flu_batuk": false,
  ///   "sehat_hari_ini": true,
  ///   "pernah_dirawat": false,
  ///   "sudah_makan": true,
  ///   "konsumsi_alkohol": false,
  ///   "konsumsi_obat": false,
  ///   "pernah_pingsan_donor": false,
  ///   "riwayat_jantung_diabetes": false,
  ///   "riwayat_hepatitis_hiv": false,
  ///   "hamil_menyusui": false,
  ///   "baru_operasi": false,
  ///   "baru_vaksin": false,
  ///   "bersedia_sukarela": true,
  /// }
  ///
  /// Return body sukses (201): { message, id_pendaftaran, nomor_antrian,
  /// lokasi, tanggal }.
  ///
  /// Kalau gagal, `ApiClient` sudah otomatis lempar `ApiException` dengan
  /// pesan dari backend, contoh:
  /// - 400: belum bisa donor lagi (jarak minimal donor terakhir)
  /// - 401: sesi habis / belum login
  /// - 404: jadwal tidak ditemukan/tidak aktif
  /// - 409: kuota penuh, atau sudah pernah daftar di jadwal yang sama
  Future<Map<String, dynamic>> daftar({
    required int idJadwal,
    required Map<String, bool> jawaban,
  }) async {
    return ApiClient.postJson('/pendaftaran', {
      'id_jadwal': idJadwal,
      'jawaban': jawaban,
    });
  }
}