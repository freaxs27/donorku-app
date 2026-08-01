import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_config.dart';
import '../core/api_exception.dart';

class AuthService {
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/auth/login');

    late final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak valid.', statusCode: response.statusCode);
    }

    if (response.statusCode == 200) {
      return body; 
    }

    throw ApiException(
      body['message'] as String? ?? 'Login gagal',
      statusCode: response.statusCode,
    );
  }
  /// Kirim data pendaftaran lengkap (gabungan R-001, R-002, R-003) ke
  /// backend sekaligus, dalam 1 panggilan multipart (karena ada file
  /// foto_diri yang perlu di-upload).
  ///
  /// [fotoKtpPath] sengaja dikosongkan (default '') untuk sementara,
  /// karena endpoint `ocr-ktp` backend belum bisa dipakai untuk simpan
  /// file KTP (masih placeholder, lihat catatan sebelumnya). Backend
  /// akan otomatis menyimpannya sebagai `null` di database.
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
    final uri = Uri.parse('${ApiConfig.baseUrl}/auth/register');
    final request = http.MultipartRequest('POST', uri);

    request.fields['nama_lengkap'] = namaLengkap;
    request.fields['email'] = email;
    request.fields['no_hp'] = noHp;
    request.fields['kota'] = kota;
    request.fields['password'] = password;
    request.fields['password_confirm'] = passwordConfirm;
    request.fields['nik'] = nik;
    request.fields['tanggal_lahir'] =
        '${tanggalLahir.year.toString().padLeft(4, '0')}-${tanggalLahir.month.toString().padLeft(2, '0')}-${tanggalLahir.day.toString().padLeft(2, '0')}';
    request.fields['alamat'] = alamat;
    request.fields['golongan_darah'] = golonganDarah;
    request.fields['profesi'] = profesi;
    request.fields['jenis_kelamin'] = jenisKelamin;
    request.fields['foto_ktp_path'] = fotoKtpPath;

    if (fotoDiri != null) {
      request.files.add(await http.MultipartFile.fromPath('foto_diri', fotoDiri.path));
    }

    late final http.Response response;
    try {
      final streamed = await request.send().timeout(const Duration(seconds: 30));
      response = await http.Response.fromStream(streamed);
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak valid.', statusCode: response.statusCode);
    }

    if (response.statusCode == 201) {
      return body; 
    }

    throw ApiException(
      body['message'] as String? ?? 'Gagal membuat akun',
      statusCode: response.statusCode,
    );
  }

  // LP-001: minta kode OTP dikirim ke email.
  Future<String> kirimOtpLupaPassword({required String email}) async {
    final body = await _postJson('/auth/forgot-password', {'email': email});
    return body['message'] as String? ?? 'Kode OTP telah dikirim';
  }

  // LP-002: verifikasi kode OTP  
  Future<String> verifikasiOtp({required String email, required String otp}) async {
    final body = await _postJson('/auth/verify-otp', {'email': email, 'otp': otp});
    return body['message'] as String? ?? 'Kode OTP valid';
  }

  // LP-003: set password baru. 
  Future<String> resetPassword({
    required String email,
    required String otp,
    required String passwordBaru,
  }) async {
    final body = await _postJson('/auth/reset-password', {
      'email': email,
      'otp': otp,
      'password_baru': passwordBaru,
    });
    return body['message'] as String? ?? 'Password berhasil direset';
  }

  Future<Map<String, dynamic>> _postJson(String path, Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    late final http.Response response;
    try {
      response = await http
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }

    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak valid.', statusCode: response.statusCode);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    throw ApiException(
      body['message'] as String? ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
    );
  }
}