import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  SessionService._();

  static const _keyToken = 'access_token';
  static const _keyIdPendonor = 'id_pendonor';
  static const _keyNama = 'nama_lengkap';
  static const _keyEmail = 'email';

  /// Token disimpan di secure storage (Keychain / Keystore).
  /// Data profil non-sensitif tetap di SharedPreferences.
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> simpanSesi({
    required String token,
    required int idPendonor,
    required String namaLengkap,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await _secureStorage.write(key: _keyToken, value: token);
    // Bersihkan sisa token lama di SharedPreferences (migrasi).
    await prefs.remove(_keyToken);
    await prefs.setInt(_keyIdPendonor, idPendonor);
    await prefs.setString(_keyNama, namaLengkap);
    await prefs.setString(_keyEmail, email);
  }

  static Future<String?> ambilToken() async {
    final token = await _secureStorage.read(key: _keyToken);
    if (token != null && token.isNotEmpty) return token;

    // Migrasi sekali: token lama masih di SharedPreferences.
    final prefs = await SharedPreferences.getInstance();
    final tokenLama = prefs.getString(_keyToken);
    if (tokenLama != null && tokenLama.isNotEmpty) {
      await _secureStorage.write(key: _keyToken, value: tokenLama);
      await prefs.remove(_keyToken);
      return tokenLama;
    }
    return null;
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
    await _secureStorage.delete(key: _keyToken);
    await prefs.remove(_keyToken);
    await prefs.remove(_keyIdPendonor);
    await prefs.remove(_keyNama);
    await prefs.remove(_keyEmail);
  }
}
