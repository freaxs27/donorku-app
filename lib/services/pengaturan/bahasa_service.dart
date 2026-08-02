import 'package:shared_preferences/shared_preferences.dart';

/// Persistensi pilihan bahasa aplikasi.
class BahasaService {
  BahasaService._();

  static const _keyBahasa = 'app_bahasa';

  static Future<String?> ambilKodeBahasa() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyBahasa);
  }

  static Future<void> simpanKodeBahasa(String kode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBahasa, kode);
  }
}
