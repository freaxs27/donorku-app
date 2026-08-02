import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/api_config.dart';
import '../core/api_exception.dart';
import '../core/api_client.dart';
import '../auth/session_service.dart';
import '../../model/data_profil.dart';

class ProfilService {
  Future<DataProfil> ambilProfil() async {
    final body = await ApiClient.get('/profil');
    return DataProfil.fromJson(body);
  }

  Future<void> updateProfil(Map<String, String> data) async {
    await ApiClient.put('/profil', data);
  }

  /// Upload foto profil ke public/uploads/profil_pendonor di server.
  /// Kirim sebagai multipart/form-data dengan field nama "foto".
  Future<String> uploadFotoProfil(File foto) async {
    final token = await SessionService.ambilToken();
    if (token == null || token.isEmpty) {
      throw ApiException('Sesi login sudah habis, silakan login ulang.');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}/profil/foto');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(await http.MultipartFile.fromPath('foto', foto.path));

    late final http.StreamedResponse streamed;
    try {
      streamed = await request.send().timeout(const Duration(seconds: 30));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }

    final body = await streamed.stream.bytesToString();
    Map<String, dynamic> json;
    try {
      json = jsonDecode(body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak valid.', statusCode: streamed.statusCode);
    }

    if (streamed.statusCode == 200) {
      return json['foto_profil'] as String;
    }

    if (streamed.statusCode == 401) {
      throw ApiException(
        json['message'] as String? ?? 'Sesi login sudah habis',
        statusCode: 401,
      );
    }

    throw ApiException(
      json['message'] as String? ?? 'Gagal mengupload foto',
      statusCode: streamed.statusCode,
    );
  }

  Future<void> gantiPassword({
    required String passwordSekarang,
    required String passwordBaru,
    required String konfirmasiPasswordBaru,
  }) async {
    await ApiClient.patch('/profil/password', {
      'password_sekarang': passwordSekarang,
      'password_baru': passwordBaru,
      'konfirmasi_password_baru': konfirmasiPasswordBaru,
    });
  }
}