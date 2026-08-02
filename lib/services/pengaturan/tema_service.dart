import 'package:shared_preferences/shared_preferences.dart';

/// Persistensi pilihan tema aplikasi.
class TemaService {
  TemaService._();

  static const _keyTema = 'app_tema';

  static Future<String?> ambilKodeTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyTema);
  }

  static Future<void> simpanKodeTema(String kode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyTema, kode);
  }
}
