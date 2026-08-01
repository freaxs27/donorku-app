/// Menampung semua data pendaftaran yang dikumpulkan bertahap dari
/// R-001 -> R-002 -> R-003, sebelum dikirim sekaligus ke API `/register`
/// di step terakhir (R-003).
///
/// Field dari R-002 & R-003 nullable, karena belum terisi saat baru
/// keluar dari R-001.
class DataRegister {
  // Dari R-001
  final String namaLengkap;
  final String email;
  final String noHp;
  final String kota;
  final String password;
  final String passwordConfirm;

  // Dari R-002 (hasil OCR KTP, bisa diedit manual oleh user)
  final String? nik;
  final DateTime? tanggalLahir;
  final String? alamat;
  final String? golonganDarah;
  final String? profesi;
  final String? jenisKelamin; // 'Laki-laki' atau 'Perempuan'

  const DataRegister({
    required this.namaLengkap,
    required this.email,
    required this.noHp,
    required this.kota,
    required this.password,
    required this.passwordConfirm,
    this.nik,
    this.tanggalLahir,
    this.alamat,
    this.golonganDarah,
    this.profesi,
    this.jenisKelamin,
  });

  DataRegister copyWith({
    String? nik,
    DateTime? tanggalLahir,
    String? alamat,
    String? golonganDarah,
    String? profesi,
    String? jenisKelamin,
  }) {
    return DataRegister(
      namaLengkap: namaLengkap,
      email: email,
      noHp: noHp,
      kota: kota,
      password: password,
      passwordConfirm: passwordConfirm,
      nik: nik ?? this.nik,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      alamat: alamat ?? this.alamat,
      golonganDarah: golonganDarah ?? this.golonganDarah,
      profesi: profesi ?? this.profesi,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
    );
  }
}