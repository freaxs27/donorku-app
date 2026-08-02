class DataNotifikasi {
  final int idNotifikasi;
  final String tipe;
  final String judul;
  final String pesan;
  final bool isRead;
  final String waktu;

  DataNotifikasi({
    required this.idNotifikasi,
    required this.tipe,
    required this.judul,
    required this.pesan,
    required this.isRead,
    required this.waktu,
  });

  factory DataNotifikasi.fromJson(Map<String, dynamic> json) {
    return DataNotifikasi(
      idNotifikasi: json['id_notifikasi'] as int,
      tipe: json['tipe'] as String,
      judul: json['judul'] as String,
      pesan: json['pesan'] as String,
      isRead: json['is_read'] as bool? ?? false,
      waktu: json['waktu'] as String,
    );
  }
}