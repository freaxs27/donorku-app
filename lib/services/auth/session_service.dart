import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  SessionService._();

  static const _keyToken = 'access_token';
  static const _keyIdPendonor = 'id_pendonor';
  static const _keyNama = 'nama_lengkap';
  static const _keyEmail = 'email';

  static Future<void> simpanSesi({
    required String token,
    required int idPendonor,
    required String namaLengkap,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyToken, token);
    await prefs.setInt(_keyIdPendonor, idPendonor);
    await prefs.setString(_keyNama, namaLengkap);
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> ambilToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<bool> sudahLogin() async {
    final token = await ambilToken();
    return token != null && token.isNotEmpty;
  }

  static Future<String?> ambilNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyNama);
  }

  static Future<String?> ambilEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyEmail);
  }

  static Future<void> hapusSesi() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyToken);
    await prefs.remove(_keyIdPendonor);
    await prefs.remove(_keyNama);
    await prefs.remove(_keyEmail);
  }
}