import '../core/api_client.dart';
import '../../model/jadwal_ringkas.dart';

/// Service untuk D-002: ambil daftar jadwal donor sesuai tanggal yang
/// dipilih user, untuk ditampilkan sebagai card di bawah date picker.
///
/// Sesuai kontrak backend: GET /api/mobile/jadwal?tanggal=YYYY-MM-DD
/// (kalau tidak ada jadwal utk tanggal itu, backend balikin array kosong,
/// BUKAN error -- jadi array kosong = tampilkan "tidak ada jadwal").
///
/// Pakai `ApiClient` terpusat (sama seperti `LokasiService`), jadi tidak
/// perlu urus header/token/parsing error manual di sini.
class JadwalService {
  /// [tanggal] dikirim sebagai `YYYY-MM-DD` sesuai timezone lokal device,
  /// supaya cocok dengan filter tanggal di backend (bukan UTC, biar tidak
  /// geser hari kalau device di WIB/WITA/WIT).
  Future<List<JadwalRingkas>> ambilJadwalByTanggal(DateTime tanggal) async {
    final tanggalFormat =
        '${tanggal.year.toString().padLeft(4, '0')}-${tanggal.month.toString().padLeft(2, '0')}-${tanggal.day.toString().padLeft(2, '0')}';

    final body = await ApiClient.getList('/jadwal?tanggal=$tanggalFormat');

    return body
        .map((e) => JadwalRingkas.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}