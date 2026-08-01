import 'dart:convert';
import '../services/core/api_config.dart';

/// Model ringkasan jadwal donor untuk D-002 (pilih jadwal pendaftaran).
/// Sesuai response backend: GET /api/mobile/jadwal?tanggal=YYYY-MM-DD
///
/// Backend SUDAH memfilter (jangan difilter ulang manual di Flutter):
/// - Hanya jadwal dengan status_jadwal "aktif"
/// - Hanya tanggal yang cocok dengan query `tanggal`
/// - Kalau tanggal yang dipilih = hari ini, jadwal yang jam_selesai-nya
///   sudah lewat jam sekarang otomatis TIDAK ikut
/// - Hanya jadwal yang sisa_kuota masih > 0
///
/// Jadi kalau list-nya kosong, artinya memang tidak ada jadwal untuk
/// tanggal itu -> tampilkan "Tidak ada jadwal tersedia" di D-002.
class JadwalRingkas {
  final int idJadwal;
  final DateTime tanggalPelaksanaan;
  final DateTime jamMulai;
  final DateTime jamSelesai;
  final int kuota;
  final int sisaKuota;
  final LokasiRingkas lokasi;

  JadwalRingkas({
    required this.idJadwal,
    required this.tanggalPelaksanaan,
    required this.jamMulai,
    required this.jamSelesai,
    required this.kuota,
    required this.sisaKuota,
    required this.lokasi,
  });

  factory JadwalRingkas.fromJson(Map<String, dynamic> json) {
    return JadwalRingkas(
      idJadwal: json['id_jadwal'] as int,
      tanggalPelaksanaan: DateTime.parse(json['tanggal_pelaksanaan'] as String),
      jamMulai: DateTime.parse(json['jam_mulai'] as String),
      jamSelesai: DateTime.parse(json['jam_selesai'] as String),
      kuota: json['kuota'] as int,
      sisaKuota: json['sisa_kuota'] as int,
      lokasi: LokasiRingkas.fromJson(json['lokasi'] as Map<String, dynamic>),
    );
  }

  /// Format "08:00" dari kolom Time backend (yang disimpan sebagai
  /// DateTime bertanggal 1970-01-01 oleh Prisma @db.Time).
  String get jamMulaiFormat =>
      '${jamMulai.hour.toString().padLeft(2, '0')}:${jamMulai.minute.toString().padLeft(2, '0')}';

  String get jamSelesaiFormat =>
      '${jamSelesai.hour.toString().padLeft(2, '0')}:${jamSelesai.minute.toString().padLeft(2, '0')}';
}

class LokasiRingkas {
  final int idLokasi;
  final String namaLokasi;
  final String alamat;
  final double? latitude;
  final double? longitude;
  final String? fotoUrl;

  LokasiRingkas({
    required this.idLokasi,
    required this.namaLokasi,
    required this.alamat,
    this.latitude,
    this.longitude,
    this.fotoUrl,
  });

  factory LokasiRingkas.fromJson(Map<String, dynamic> json) {
    return LokasiRingkas(
      idLokasi: json['id_lokasi'] as int,
      namaLokasi: json['nama_lokasi'] as String,
      alamat: json['alamat'] as String,
      latitude: _parseDouble(json['latitude']),
      longitude: _parseDouble(json['longitude']),
      fotoUrl: ApiConfig.urlMedia(_ekstrakPathFoto(json['foto_lokasi'])),
    );
  }

  /// Backend Prisma pakai tipe `Decimal` untuk latitude/longitude, yang
  /// di-serialize jadi String oleh Next.js (misal "-6.9034700"), BUKAN
  /// angka langsung -- jadi tidak bisa di-cast `as num?` biasa.
  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  /// Ekstrak path foto dari `foto_lokasi`, yang di database ternyata
  /// disimpan dalam bentuk string berisi array yang di-stringify, misal
  /// `["/uploads/lokasi/xxx.jpg"]` (bukan cuma "/uploads/lokasi/xxx.jpg"
  /// polos). Sama persis dengan penanganan di halaman Beranda.
  static String? _ekstrakPathFoto(dynamic raw) {
    if (raw == null || raw is! String || raw.isEmpty) return null;

    final teks = raw.trim();

    if (teks.startsWith('[') && teks.endsWith(']')) {
      try {
        final hasil = jsonDecode(teks);
        if (hasil is List && hasil.isNotEmpty) {
          return hasil.first?.toString();
        }
        return null;
      } catch (_) {
        return null;
      }
    }

    return teks;
  }
}