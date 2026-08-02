import '../core/locale/app_strings.dart';

class ItemPendaftaran {
  final int idPendaftaran;
  final int nomorAntrian;
  final DateTime tanggalDaftar;
  final String statusPendaftaran;
  final JadwalPendaftaran jadwal;
  final RiwayatSingkat? riwayat; // null kalau admin belum input hasil donor

  ItemPendaftaran({
    required this.idPendaftaran,
    required this.nomorAntrian,
    required this.tanggalDaftar,
    required this.statusPendaftaran,
    required this.jadwal,
    required this.riwayat,
  });

  factory ItemPendaftaran.fromJson(Map<String, dynamic> json) {
    return ItemPendaftaran(
      idPendaftaran: json['id_pendaftaran'] as int,
      nomorAntrian: json['nomor_antrian'] as int,
      tanggalDaftar: DateTime.parse(json['tanggal_daftar'] as String),
      statusPendaftaran: json['status_pendaftaran'] as String,
      jadwal: JadwalPendaftaran.fromJson(json['jadwal'] as Map<String, dynamic>),
      riwayat: json['riwayat'] != null
          ? RiwayatSingkat.fromJson(json['riwayat'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Label + warna yang ditampilkan di card.
  /// Prioritas: kalau sudah ada hasil riwayat dari admin → pakai itu.
  /// Kalau belum → pakai status pendaftaran.
  String get statusLabel {
    final s = AppStrings.current;
    if (riwayat != null) {
      return s.labelStatusDonor(riwayat!.statusDonor);
    }
    return s.labelStatusPendaftaran(statusPendaftaran);
  }

  /// Warna badge status
  StatusWarna get warnaStatus {
    if (riwayat != null) {
      return switch (riwayat!.statusDonor) {
        'berhasil' => StatusWarna.hijau,
        'gagal'    => StatusWarna.merah,
        'ditunda'  => StatusWarna.kuning,
        _          => StatusWarna.abu,
      };
    }
    return switch (statusPendaftaran) {
      'menunggu'    => StatusWarna.kuning,
      'diterima'    => StatusWarna.biru,
      'ditolak'     => StatusWarna.merah,
      'dibatalkan'  => StatusWarna.abu,
      'selesai'     => StatusWarna.hijau,
      'batal_hadir' => StatusWarna.merah,
      _             => StatusWarna.abu,
    };
  }

  /// Hanya tampilkan tombol Batalkan kalau masih menunggu dan belum
  /// ada hasil riwayat
  bool get bisaDibatalkan =>
      statusPendaftaran == 'menunggu' && riwayat == null;
}

enum StatusWarna { hijau, merah, kuning, biru, abu }

class JadwalPendaftaran {
  final String? tanggalPelaksanaan;
  final String jamMulai;
  final String jamSelesai;
  final String lokasi;

  JadwalPendaftaran({
    required this.tanggalPelaksanaan,
    required this.jamMulai,
    required this.jamSelesai,
    required this.lokasi,
  });

  factory JadwalPendaftaran.fromJson(Map<String, dynamic> json) {
    return JadwalPendaftaran(
      tanggalPelaksanaan: json['tanggal_pelaksanaan'] as String?,
      jamMulai: json['jam_mulai'] as String,
      jamSelesai: json['jam_selesai'] as String,
      lokasi: json['lokasi'] as String,
    );
  }

  String get tanggalFormat {
    if (tanggalPelaksanaan == null) return '-';
    return AppStrings.current.formatTanggal(DateTime.parse(tanggalPelaksanaan!));
  }
}

class RiwayatSingkat {
  final int idRiwayat;
  final String statusDonor;
  final int? darahTerkumpul;

  RiwayatSingkat({
    required this.idRiwayat,
    required this.statusDonor,
    required this.darahTerkumpul,
  });

  factory RiwayatSingkat.fromJson(Map<String, dynamic> json) {
    return RiwayatSingkat(
      idRiwayat: json['id_riwayat'] as int,
      statusDonor: json['status_donor'] as String,
      darahTerkumpul: json['darah_terkumpul'] as int?,
    );
  }
}