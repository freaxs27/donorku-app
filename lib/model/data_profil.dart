import '../services/core/api_config.dart';

class DataProfil {
  final String namaLengkap;
  final String email;
  final String? noHp;
  final DateTime tanggalLahir;
  final String? alamat;
  final String? kota;
  final String? profesi;
  final String golonganDarah;
  final String? fotoProfil;
  final int totalDonasi;
  final int totalMlDarah;

  DataProfil({
    required this.namaLengkap,
    required this.email,
    required this.noHp,
    required this.tanggalLahir,
    required this.alamat,
    required this.kota,
    required this.profesi,
    required this.golonganDarah,
    required this.fotoProfil,
    required this.totalDonasi,
    required this.totalMlDarah,
  });

  factory DataProfil.fromJson(Map<String, dynamic> json) {
    return DataProfil(
      namaLengkap:   json['nama_lengkap'] as String,
      email:         json['email'] as String,
      noHp:          json['no_hp'] as String?,
      tanggalLahir:  DateTime.parse(json['tanggal_lahir'] as String),
      alamat:        json['alamat'] as String?,
      kota:          json['kota'] as String?,
      profesi:       json['profesi'] as String?,
      golonganDarah: json['golongan_darah'] as String,
      fotoProfil:    json['foto_profil'] != null
          ? ApiConfig.urlMedia(json['foto_profil'] as String)
          : null,
      totalDonasi:   (json['total_donasi'] as int?) ?? 0,
      totalMlDarah:  (json['total_ml_darah'] as int?) ?? 0,
    );
  }

  String get tanggalLahirFormat {
    return '${tanggalLahir.day} - ${tanggalLahir.month} - ${tanggalLahir.year}';
  }
}