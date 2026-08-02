import 'package:latlong2/latlong.dart';
import '../services/core/api_config.dart';

class LokasiDonor {
  final int? idLokasi;
  final String nama;
  final String alamat;
  final String? fotoAsset;
  final String? fotoUrl;
  final LatLng posisi;
  final String? statusDonor;
  // Data jadwal aktif — diambil dari jadwal_donor, bukan lokasi_donor
  final String? jamMulai;
  final String? jamSelesai;
  final int? sisaKuota;
  final DateTime? tanggalPelaksanaan;

  const LokasiDonor({
    this.idLokasi,
    required this.nama,
    required this.alamat,
    this.fotoAsset,
    this.fotoUrl,
    required this.posisi,
    this.statusDonor,
    this.jamMulai,
    this.jamSelesai,
    this.sisaKuota,
    this.tanggalPelaksanaan,
  });

  factory LokasiDonor.fromJson(Map<String, dynamic> json) {
    return LokasiDonor(
      idLokasi: _keInt(json['id_lokasi']),
      nama: json['nama_lokasi'] as String? ?? '-',
      alamat: json['alamat'] as String? ?? '-',
      fotoUrl: ApiConfig.urlMedia(_ekstrakPathFoto(json['foto_lokasi'])),
      posisi: LatLng(
        _keDouble(json['latitude']) ?? 0,
        _keDouble(json['longitude']) ?? 0,
      ),
      statusDonor: json['status_donor'] as String?,
      jamMulai: json['jam_mulai'] as String?,
      jamSelesai: json['jam_selesai'] as String?,
      sisaKuota: _keInt(json['sisa_kuota']),
      tanggalPelaksanaan: json['tanggal_pelaksanaan'] != null
          ? DateTime.tryParse(json['tanggal_pelaksanaan'] as String)
          : null,
    );
  }

  /// Format tanggal "5 Agustus 2026"
  String? get tanggalFormat {
    if (tanggalPelaksanaan == null) return null;
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${tanggalPelaksanaan!.day} ${bulan[tanggalPelaksanaan!.month - 1]} ${tanggalPelaksanaan!.year}';
  }

  /// Label jam + sisa kuota untuk ditampilkan di kartu
  String? get jadwalLabel {
    if (jamMulai == null || jamSelesai == null) return null;
    final kuota = sisaKuota != null ? '  Sisa $sisaKuota kuota' : '';
    return '$jamMulai - $jamSelesai$kuota';
  }
}

int? _keInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v);
  return null;
}

double? _keDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

String? _ekstrakPathFoto(dynamic raw) {
  if (raw == null || raw is! String || raw.isEmpty) return null;
  final teks = raw.trim();
  if (teks.startsWith('[') && teks.endsWith(']')) {
    try {
      final list = teks.substring(1, teks.length - 1).split(',');
      if (list.isEmpty) return null;
      return list.first.replaceAll('"', '').replaceAll('\\', '').trim();
    } catch (_) {
      return null;
    }
  }
  return teks;
}

const List<LokasiDonor> daftarLokasiDonor = [];