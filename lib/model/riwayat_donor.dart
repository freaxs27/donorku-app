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
    return RiwayatResponse(
      totalDonasi: (json['total_donasi'] as int?) ?? 0,
      totalMlDarah: (json['total_ml_darah'] as int?) ?? 0,
      bolehDonorSekarang: (json['boleh_donor_sekarang'] as bool?) ?? true,
      tanggalBolehDonor: json['tanggal_boleh_donor'] != null
          ? DateTime.parse(json['tanggal_boleh_donor'] as String)
          : null,
      statusKesehatan: json['status_kesehatan'] != null
          ? StatusKesehatan.fromJson(json['status_kesehatan'] as Map<String, dynamic>)
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

  StatusKesehatan({
    required this.hemoglobin,
    required this.tekananDarahSistole,
    required this.tekananDarahDiastole,
    required this.statusSkrining,
  });

  factory StatusKesehatan.fromJson(Map<String, dynamic> json) {
    return StatusKesehatan(
      hemoglobin: json['hemoglobin']?.toString(),
      tekananDarahSistole: json['tekanan_darah_sistole'] as int?,
      tekananDarahDiastole: json['tekanan_darah_diastole'] as int?,
      statusSkrining: json['status_skrining'] as String?,
    );
  }

  /// "120/80" atau null
  String? get tekananDarahFormat {
    if (tekananDarahSistole == null || tekananDarahDiastole == null) return null;
    return '$tekananDarahSistole/$tekananDarahDiastole';
  }
}

class ItemRiwayat {
  final int idRiwayat;
  final DateTime tanggalDonor;
  final String lokasiDonor;
  final int? darahTerkumpul;
  final String statusDonor;

  ItemRiwayat({
    required this.idRiwayat,
    required this.tanggalDonor,
    required this.lokasiDonor,
    required this.darahTerkumpul,
    required this.statusDonor,
  });

  factory ItemRiwayat.fromJson(Map<String, dynamic> json) {
    return ItemRiwayat(
      idRiwayat: json['id_riwayat'] as int,
      tanggalDonor: DateTime.parse(json['tanggal_donor'] as String),
      lokasiDonor: json['lokasi_donor'] as String,
      darahTerkumpul: json['darah_terkumpul'] as int?,
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