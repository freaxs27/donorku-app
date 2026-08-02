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

  static const Duration _timeoutDefault = Duration(seconds: 20);
  static const Duration _timeoutMultipart = Duration(seconds: 30);

  static Future<Map<String, String>> _headerJson({bool withAuth = true}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (withAuth) {
      final token = await SessionService.ambilToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return headers;
  }

  /// Hapus sesi + panggil [onUnauthorized] (sekali saja per gelombang 401).
  static Future<void> _tangani401(String pesan) async {
    if (!_sedangRedirect401) {
      _sedangRedirect401 = true;
      await SessionService.hapusSesi();
      onUnauthorized?.call();
      Future<void>.delayed(const Duration(seconds: 2), () {
        _sedangRedirect401 = false;
      });
    }
    throw ApiException(pesan, statusCode: 401);
  }

  static Future<http.Response> _kirim(
    Future<http.Response> Function() request, {
    Duration timeout = _timeoutDefault,
  }) async {
    try {
      return await request().timeout(timeout);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Tidak bisa terhubung ke server. Cek koneksi internet Anda.',
      );
    }
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _kirim(
      () async => http.get(uri, headers: await _headerJson()),
    );
    return _prosesRespons(response);
  }

  static Future<List<dynamic>> getList(String path) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _kirim(
      () async => http.get(uri, headers: await _headerJson()),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        return jsonDecode(response.body) as List<dynamic>;
      } catch (_) {
        throw ApiException(
          'Respons server tidak valid.',
          statusCode: response.statusCode,
        );
      }
    }

    final body = _cobaDecodeMap(response.body);

    if (response.statusCode == 401) {
      await _tangani401(
        body['message'] as String? ??
            'Sesi login sudah habis, silakan login ulang',
      );
    }

    throw ApiException(
      body['message'] as String? ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
    );
  }

  static Future<Map<String, dynamic>> postJson(
    String path,
    Map<String, dynamic> data, {
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _kirim(
      () async => http.post(
        uri,
        headers: await _headerJson(withAuth: withAuth),
        body: jsonEncode(data),
      ),
    );
    return _prosesRespons(response);
  }

  static Future<Map<String, dynamic>> put(
    String path,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _kirim(
      () async => http.put(
        uri,
        headers: await _headerJson(),
        body: jsonEncode(data),
      ),
    );
    return _prosesRespons(response);
  }

  static Future<Map<String, dynamic>> patch(
    String path,
    Map<String, dynamic> data,
  ) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final response = await _kirim(
      () async => http.patch(
        uri,
        headers: await _headerJson(),
        body: jsonEncode(data),
      ),
    );
    return _prosesRespons(response);
  }

  /// Multipart POST terpusat (register, upload foto, dll).
  /// [withAuth] false untuk endpoint publik seperti register.
  static Future<Map<String, dynamic>> postMultipart(
    String path, {
    Map<String, String> fields = const {},
    List<http.MultipartFile> files = const [],
    bool withAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final request = http.MultipartRequest('POST', uri);

    if (withAuth) {
      final token = await SessionService.ambilToken();
      if (token != null && token.isNotEmpty) {
        request.headers['Authorization'] = 'Bearer $token';
      }
    }

    request.fields.addAll(fields);
    request.files.addAll(files);

    late final http.Response response;
    try {
      final streamed = await request.send().timeout(_timeoutMultipart);
      response = await http.Response.fromStream(streamed);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Tidak bisa terhubung ke server. Cek koneksi internet Anda.',
      );
    }

    return _prosesRespons(response);
  }

  static Map<String, dynamic> _cobaDecodeMap(String raw) {
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  static Future<Map<String, dynamic>> _prosesRespons(
    http.Response response,
  ) async {
    final body = _cobaDecodeMap(response.body);
    if (body.isEmpty && response.body.isNotEmpty) {
      throw ApiException(
        'Respons server tidak valid.',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }

    if (response.statusCode == 401) {
      await _tangani401(
        body['message'] as String? ??
            'Sesi login sudah habis, silakan login ulang',
      );
    }

    throw ApiException(
      body['message'] as String? ?? 'Terjadi kesalahan',
      statusCode: response.statusCode,
    );
  }
}
