import 'package:flutter/material.dart';
import '../../services/pengaturan/bahasa_service.dart';

/// Bahasa yang didukung aplikasi.
enum AppBahasa {
  indonesia('id', 'Indonesia', 'Bahasa Indonesia'),
  english('en', 'English', 'English');

  const AppBahasa(this.kode, this.namaTampil, this.deskripsi);

  final String kode;
  final String namaTampil;
  final String deskripsi;

  Locale get locale => Locale(kode);

  static AppBahasa dariKode(String? kode) {
    return AppBahasa.values.firstWhere(
      (b) => b.kode == kode,
      orElse: () => AppBahasa.indonesia,
    );
  }
}

/// Pengontrol locale global — didengar oleh [MaterialApp].
class LocaleController extends ChangeNotifier {
  LocaleController._();
  static final LocaleController instance = LocaleController._();

  AppBahasa _bahasa = AppBahasa.indonesia;
  bool _siap = false;

  AppBahasa get bahasa => _bahasa;
  Locale get locale => _bahasa.locale;
  bool get siap => _siap;

  Future<void> muat() async {
    final kode = await BahasaService.ambilKodeBahasa();
    _bahasa = AppBahasa.dariKode(kode);
    _siap = true;
    notifyListeners();
  }

  Future<void> setBahasa(AppBahasa bahasa) async {
    if (_bahasa == bahasa) return;
    _bahasa = bahasa;
    await BahasaService.simpanKodeBahasa(bahasa.kode);
    notifyListeners();
  }
}
