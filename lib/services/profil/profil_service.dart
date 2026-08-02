import 'dart:io';
import 'package:http/http.dart' as http;
import '../core/api_client.dart';
import '../../model/data_profil.dart';

class ProfilService {
  Future<DataProfil> ambilProfil() async {
    final body = await ApiClient.get('/profil');
    return DataProfil.fromJson(body);
  }

  Future<void> updateProfil(Map<String, String> data) async {
    await ApiClient.put('/profil', data);
  }

  /// Upload foto profil (multipart field "foto").
  /// 401 diurus [ApiClient] (clear sesi + redirect Login).
  Future<String> uploadFotoProfil(File foto) async {
    final body = await ApiClient.postMultipart(
      '/profil/foto',
      files: [await http.MultipartFile.fromPath('foto', foto.path)],
    );
    return body['foto_profil'] as String;
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
