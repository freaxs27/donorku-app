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

  const LokasiDonor({
    this.idLokasi,
    required this.nama,
    required this.alamat,
    this.fotoAsset,
    this.fotoUrl,
    required this.posisi,
    this.statusDonor,
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
    );
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

const List<LokasiDonor> daftarLokasiDonor = [
  LokasiDonor(
    nama: 'Rumah Sakit Pasundan',
    alamat: 'Lebakgede, Coblong',
    fotoAsset: 'assets/images/lokasi/rs-pasundan.jpg',
    posisi: LatLng(-6.8916, 107.6107),
  ),
  LokasiDonor(
    nama: 'Rumah Sakit Santo Boromeus',
    alamat: 'Lebakgede, Coblong',
    fotoAsset: 'assets/images/lokasi/rs-santo.jpg',
    posisi: LatLng(-6.8975, 107.6100),
  ),
  LokasiDonor(
    nama: 'Rumah Sakit Kartini Bandung',
    alamat: 'Negiasari, Cibeunying Kaler',
    posisi: LatLng(-6.9012, 107.6205),
  ),
  LokasiDonor(
    nama: 'RSKB Helmahera Siaga',
    alamat: 'Citarum, Bandung Wetan',
    posisi: LatLng(-6.9068, 107.6152),
  ),
  LokasiDonor(
    nama: 'Rumah Sakit Veteran',
    alamat: 'Kb. Pisang, Sumur Bandung',
    posisi: LatLng(-6.9143, 107.6098),
  ),
];