import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import 'api_exception.dart';
import '../auth/session_service.dart';

class ApiClient {
  ApiClient._();

  /// Dipasang dari [DonorkuApp] agar 401 bisa redirect ke Login tanpa
  /// bergantung ke BuildContext di tiap halaman.
  static void Function()? onUnauthorized;

  /// Cegah double-redirect kalau beberapa request gagal 401 bersamaan.
  static bool _sedangRedirect401 = false;

  static Future<Map<String, String>> _headerDenganToken() async {
    final token = await SessionService.ambilToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  /// Hapus sesi + panggil [onUnauthorized] (sekali saja per gelombang 401).
  static Future<void> _tangani401(String pesan) async {
    if (!_sedangRedirect401) {
      _sedangRedirect401 = true;
      await SessionService.hapusSesi();
      onUnauthorized?.call();
      // Izinkan redirect lagi setelah user sempat login ulang.
      Future<void>.delayed(const Duration(seconds: 2), () {
        _sedangRedirect401 = false;
      });
    }
    throw ApiException(pesan, statusCode: 401);
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    late final http.Response response;
    try {
      response = await http
          .get(uri, headers: await _headerDenganToken())
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }
    return _prosesRespons(response);
  }

  static Future<List<dynamic>> getList(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    late final http.Response response;
    try {
      response = await http
          .get(uri, headers: await _headerDenganToken())
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body) as List<dynamic>;
      } catch (_) {
        throw ApiException('Respons server tidak valid.', statusCode: response.statusCode);
      }
    }

    Map<String, dynamic> body = {};
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {}

    if (response.statusCode == 401) {
      await _tangani401(
        body['message'] as String? ?? 'Sesi login sudah habis, silakan login ulang',
      );
    }

    throw ApiException(
      body['message'] as String? ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
    );
  }

  static Future<Map<String, dynamic>> postJson(String path, Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    late final http.Response response;
    try {
      response = await http
          .post(uri, headers: await _headerDenganToken(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }
    return _prosesRespons(response);
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    late final http.Response response;
    try {
      response = await http
          .put(uri, headers: await _headerDenganToken(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }
    return _prosesRespons(response);
  }

  static Future<Map<String, dynamic>> patch(String path, Map<String, dynamic> data) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    late final http.Response response;
    try {
      response = await http
          .patch(uri, headers: await _headerDenganToken(), body: jsonEncode(data))
          .timeout(const Duration(seconds: 20));
    } catch (e) {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    }
    return _prosesRespons(response);
  }

  static Future<Map<String, dynamic>> _prosesRespons(http.Response response) async {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException('Respons server tidak valid.', statusCode: response.statusCode);
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    if (response.statusCode == 401) {
      await _tangani401(
        body['message'] as String? ?? 'Sesi login sudah habis, silakan login ulang',
      );
    }

    throw ApiException(
      body['message'] as String? ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
    );
  }
}
