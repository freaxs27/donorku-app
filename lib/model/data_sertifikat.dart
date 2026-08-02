import '../core/locale/app_strings.dart';

class DataSertifikat {
  final int idRiwayat;
  final String nomorSertifikat;
  final String namaPendonor;
  final DateTime tanggalDonor;
  final String lokasiDonor;
  final int darahTerkumpul;
  final String golonganDarah;

  DataSertifikat({
    required this.idRiwayat,
    required this.nomorSertifikat,
    required this.namaPendonor,
    required this.tanggalDonor,
    required this.lokasiDonor,
    required this.darahTerkumpul,
    required this.golonganDarah,
  });

  factory DataSertifikat.fromJson(Map<String, dynamic> json) {
    return DataSertifikat(
      idRiwayat: json['id_riwayat'] as int,
      nomorSertifikat: json['nomor_sertifikat'] as String,
      namaPendonor: json['nama_pendonor'] as String,
      tanggalDonor: DateTime.parse(json['tanggal_donor'] as String),
      lokasiDonor: json['lokasi_donor'] as String,
      darahTerkumpul: (json['darah_terkumpul'] as int?) ?? 0,
      golonganDarah: json['golongan_darah'] as String,
    );
  }

  String get tanggalFormat =>
      AppStrings.current.formatTanggal(tanggalDonor);

  /// Label pendek untuk grid galeri: "Donor #N - DD Bulan YYYY"
  String labelGaleri(int urutan) => 'Donor #$urutan - $tanggalFormat';
}