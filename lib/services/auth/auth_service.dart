import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) {
    return ApiClient.postJson(
      '/auth/login',
      {'email': email, 'password': password},
      withAuth: false,
    );
  }

  /// Kirim data pendaftaran lengkap (R-001 + R-002 + R-003) sebagai multipart
  /// karena ada file [fotoDiri].
  ///
  /// [fotoKtpPath] sengaja boleh kosong — endpoint simpan KTP backend
  /// masih placeholder.
  Future<Map<String, dynamic>> register({
    required String namaLengkap,
    required String email,
    required String noHp,
    required String kota,
    required String password,
    required String passwordConfirm,
    required String nik,
    required DateTime tanggalLahir,
    required String alamat,
    required String golonganDarah,
    required String profesi,
    required String jenisKelamin,
    File? fotoDiri,
    String fotoKtpPath = '',
  }) async {
    final files = <http.MultipartFile>[];
    if (fotoDiri != null) {
      files.add(await http.MultipartFile.fromPath('foto_diri', fotoDiri.path));
    }

    return ApiClient.postMultipart(
      '/auth/register',
      withAuth: false,
      fields: {
        'nama_lengkap': namaLengkap,
        'email': email,
        'no_hp': noHp,
        'kota': kota,
        'password': password,
        'password_confirm': passwordConfirm,
        'nik': nik,
        'tanggal_lahir':
            '${tanggalLahir.year.toString().padLeft(4, '0')}-'
            '${tanggalLahir.month.toString().padLeft(2, '0')}-'
            '${tanggalLahir.day.toString().padLeft(2, '0')}',
        'alamat': alamat,
        'golongan_darah': golonganDarah,
        'profesi': profesi,
        'jenis_kelamin': jenisKelamin,
        'foto_ktp_path': fotoKtpPath,
      },
      files: files,
    );
  }

  Future<String> kirimOtpLupaPassword({required String email}) async {
    final body = await ApiClient.postJson(
      '/auth/forgot-password',
      {'email': email},
      withAuth: false,
    );
    return body['message'] as String? ?? 'Kode OTP telah dikirim';
  }

  Future<String> verifikasiOtp({
    required String email,
    required String otp,
  }) async {
    final body = await ApiClient.postJson(
      '/auth/verify-otp',
      {'email': email, 'otp': otp},
      withAuth: false,
    );
    return body['message'] as String? ?? 'Kode OTP valid';
  }

  Future<String> resetPassword({
    required String email,
    required String otp,
    required String passwordBaru,
  }) async {
    final body = await ApiClient.postJson(
      '/auth/reset-password',
      {
        'email': email,
        'otp': otp,
        'password_baru': passwordBaru,
      },
      withAuth: false,
    );
    return body['message'] as String? ?? 'Password berhasil direset';
  }
}
