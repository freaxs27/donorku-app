import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../services/pengaturan/tema_service.dart';

/// Mode tema yang didukung aplikasi.
enum AppTema {
  terang('light', Icons.light_mode_outlined),
  gelap('dark', Icons.dark_mode_outlined),
  sistem('system', Icons.brightness_auto_outlined);

  const AppTema(this.kode, this.ikon);

  final String kode;
  final IconData ikon;

  ThemeMode get themeMode => switch (this) {
        AppTema.terang => ThemeMode.light,
        AppTema.gelap => ThemeMode.dark,
        AppTema.sistem => ThemeMode.system,
      };

  static AppTema dariKode(String? kode) {
    return AppTema.values.firstWhere(
      (t) => t.kode == kode,
      orElse: () => AppTema.sistem,
    );
  }
}

/// Pengontrol tema global — didengar oleh [MaterialApp].
class ThemeController extends ChangeNotifier {
  ThemeController._();
  static final ThemeController instance = ThemeController._();

  AppTema _tema = AppTema.sistem;
  bool _siap = false;

  AppTema get tema => _tema;
  ThemeMode get themeMode => _tema.themeMode;
  bool get siap => _siap;

  /// Apakah UI saat ini harus gelap (memperhitungkan mode sistem).
  bool get isDark {
    if (_tema == AppTema.gelap) return true;
    if (_tema == AppTema.terang) return false;
    return SchedulerBinding.instance.platformDispatcher.platformBrightness ==
        Brightness.dark;
  }

  Brightness get brightness => isDark ? Brightness.dark : Brightness.light;

  Future<void> muat() async {
    final kode = await TemaService.ambilKodeTema();
    _tema = AppTema.dariKode(kode);
    _siap = true;
    notifyListeners();
  }

  Future<void> setTema(AppTema tema) async {
    if (_tema == tema) return;
    _tema = tema;
    // Notify dulu supaya UI langsung ganti; simpan preferensi di background.
    notifyListeners();
    await TemaService.simpanKodeTema(tema.kode);
  }

  /// Dipanggil saat brightness sistem berubah (mode Sistem).
  void padaPerubahanPlatformBrightness() {
    if (_tema == AppTema.sistem) notifyListeners();
  }
}
