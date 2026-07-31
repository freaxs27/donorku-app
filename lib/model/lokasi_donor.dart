import 'package:latlong2/latlong.dart';

/// Data 1 lokasi donor darah. Dipakai bersama oleh halaman Lokasi (LK-001
/// dst.) dan Jadwal & Lokasi Donor (D-002), supaya datanya konsisten dan
/// bisa saling oper lokasi yang dipilih.
class LokasiDonor {
  final String nama;
  final String alamat;
  final String? fotoAsset; // null = pakai icon placeholder
  final LatLng posisi;

  const LokasiDonor({
    required this.nama,
    required this.alamat,
    this.fotoAsset,
    required this.posisi,
  });
}

/// Daftar lokasi donor darah. Koordinat masih dummy (area Bandung),
/// belum dari backend.
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