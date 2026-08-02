class RiwayatResponse {
  final int totalDonasi;
  final int totalMlDarah;
  final bool bolehDonorSekarang;
  final DateTime? tanggalBolehDonor;
  final StatusKesehatan? statusKesehatan;
  final List<ItemRiwayat> riwayat;

  RiwayatResponse({
    required this.totalDonasi,
    required this.totalMlDarah,
    required this.bolehDonorSekarang,
    required this.tanggalBolehDonor,
    required this.statusKesehatan,
    required this.riwayat,
  });

  factory RiwayatResponse.fromJson(Map<String, dynamic> json) {
    // Support 2 format response:
    // Format teman: { summary: { total_donasi, total_ml_darah, tanggal_boleh_donor }, ... }
    // Format flat:  { total_donasi, total_ml_darah, boleh_donor_sekarang, ... }
    final summary = json['summary'] as Map<String, dynamic>?;

    final totalDonasi = summary != null
        ? (summary['total_donasi'] as int?) ?? 0
        : (json['total_donasi'] as int?) ?? 0;

    final totalMlDarah = summary != null
        ? (summary['total_ml_darah'] as int?) ?? 0
        : (json['total_ml_darah'] as int?) ?? 0;

    // boleh_donor_sekarang: kalau pakai format summary, derive dari tanggal_boleh_donor
    final tanggalBolehDonorStr = summary != null
        ? summary['tanggal_boleh_donor'] as String?
        : json['tanggal_boleh_donor'] as String?;

    final tanggalBolehDonor = tanggalBolehDonorStr != null
        ? DateTime.tryParse(tanggalBolehDonorStr)
        : null;

    final bolehDonorSekarang = summary != null
        ? tanggalBolehDonor == null ||
          tanggalBolehDonor.isBefore(DateTime.now())
        : (json['boleh_donor_sekarang'] as bool?) ?? true;

    return RiwayatResponse(
      totalDonasi: totalDonasi,
      totalMlDarah: totalMlDarah,
      bolehDonorSekarang: bolehDonorSekarang,
      tanggalBolehDonor: tanggalBolehDonor,
      statusKesehatan: json['status_kesehatan'] != null
          ? StatusKesehatan.fromJson(
              json['status_kesehatan'] as Map<String, dynamic>)
          : null,
      riwayat: ((json['riwayat'] as List<dynamic>?) ?? [])
          .map((e) => ItemRiwayat.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StatusKesehatan {
  final String? hemoglobin;
  final int? tekananDarahSistole;
  final int? tekananDarahDiastole;
  final String? statusSkrining;
  // Format gabungan "120/80" dari teman
  final String? tekananDarahGabung;

  StatusKesehatan({
    required this.hemoglobin,
    required this.tekananDarahSistole,
    required this.tekananDarahDiastole,
    required this.statusSkrining,
    required this.tekananDarahGabung,
  });

  factory StatusKesehatan.fromJson(Map<String, dynamic> json) {
    return StatusKesehatan(
      hemoglobin: json['hemoglobin']?.toString(),
      tekananDarahSistole: json['tekanan_darah_sistole'] as int?,
      tekananDarahDiastole: json['tekanan_darah_diastole'] as int?,
      statusSkrining: json['status_skrining'] as String?,
      tekananDarahGabung: json['tekanan_darah'] as String?,
    );
  }

  String? get tekananDarahFormat {
    // Coba format gabungan dulu (dari teman: "120/80")
    if (tekananDarahGabung != null && tekananDarahGabung!.isNotEmpty) {
      return tekananDarahGabung;
    }
    // Fallback dari field terpisah
    if (tekananDarahSistole != null && tekananDarahDiastole != null) {
      return '$tekananDarahSistole/$tekananDarahDiastole';
    }
    return null;
  }
}

class ItemRiwayat {
  final int idRiwayat;
  final DateTime tanggalDonor;
  final String lokasiDonor;
  final int? darahTerkumpul;
  final String? golonganDarah;
  final String statusDonor;

  ItemRiwayat({
    required this.idRiwayat,
    required this.tanggalDonor,
    required this.lokasiDonor,
    required this.darahTerkumpul,
    required this.golonganDarah,
    required this.statusDonor,
  });

  factory ItemRiwayat.fromJson(Map<String, dynamic> json) {
    return ItemRiwayat(
      idRiwayat: json['id_riwayat'] as int,
      tanggalDonor: DateTime.parse(json['tanggal_donor'] as String),
      lokasiDonor: json['lokasi_donor'] as String,
      darahTerkumpul: json['darah_terkumpul'] as int?,
      golonganDarah: json['golongan_darah'] as String?,
      statusDonor: json['status_donor'] as String,
    );
  }

  String get tanggalFormat {
    const bulan = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${tanggalDonor.day} ${bulan[tanggalDonor.month - 1]} ${tanggalDonor.year}';
  }

  String get statusLabel => switch (statusDonor) {
        'berhasil' => 'Selesai',
        'gagal'    => 'Gagal',
        'ditunda'  => 'Ditunda',
        _          => statusDonor,
      };

  String get volumeLabel =>
      darahTerkumpul != null ? '${darahTerkumpul}ml' : '-';
}