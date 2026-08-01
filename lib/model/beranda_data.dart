import 'dart:convert';
import '../services/core/api_config.dart';

class BerandaData {
  final String namaLengkap;
  final int totalDonasi;
  final int totalMlDarah;
  final bool bolehDonorSekarang;
  final DateTime? tanggalBolehDonor;
  final List<LokasiRingkas> lokasiTersedia;

  const BerandaData({
    required this.namaLengkap,
    required this.totalDonasi,
    required this.totalMlDarah,
    required this.bolehDonorSekarang,
    required this.tanggalBolehDonor,
    required this.lokasiTersedia,
  });

  factory BerandaData.fromJson(Map<String, dynamic> json) {
    return BerandaData(
      namaLengkap: json['nama_lengkap'] as String? ?? '-',
      totalDonasi: _keInt(json['total_donasi']) ?? 0,
      totalMlDarah: _keInt(json['total_ml_darah']) ?? 0,
      bolehDonorSekarang: json['boleh_donor_sekarang'] as bool? ?? true,
      tanggalBolehDonor: json['tanggal_boleh_donor'] != null
          ? DateTime.tryParse(json['tanggal_boleh_donor'].toString())
          : null,
      lokasiTersedia: (json['lokasi_tersedia'] as List<dynamic>? ?? [])
          .map((e) => LokasiRingkas.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LokasiRingkas {
  final int idLokasi;
  final String namaLokasi;
  final String alamat;
  final double? latitude;
  final double? longitude;
  final String? fotoUrl; 

  const LokasiRingkas({
    required this.idLokasi,
    required this.namaLokasi,
    required this.alamat,
    required this.latitude,
    required this.longitude,
    required this.fotoUrl,
  });

  factory LokasiRingkas.fromJson(Map<String, dynamic> json) {
    return LokasiRingkas(
      idLokasi: _keInt(json['id_lokasi']) ?? 0,
      namaLokasi: json['nama_lokasi'] as String? ?? '-',
      alamat: json['alamat'] as String? ?? '-',
      latitude: _keDouble(json['latitude']),
      longitude: _keDouble(json['longitude']),
      fotoUrl: ApiConfig.urlMedia(_ekstrakPathFoto(json['foto_lokasi'])),
    );
  }
}

int? _keInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  if (v is String) return int.tryParse(v) ?? double.tryParse(v)?.toInt();
  return null;
}

double? _keDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

String? _ekstrakPathFoto(dynamic raw) {
  if (raw == null) return null;
  if (raw is! String || raw.isEmpty) return null;

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