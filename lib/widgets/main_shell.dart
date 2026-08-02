import 'package:flutter/material.dart';
import '../pages/beranda/beranda_page.dart';
import '../pages/lokasi/lokasi_page.dart';
import '../pages/pendaftaran/pendaftaran_page.dart';
import '../pages/riwayat/riwayat_page.dart';
import '../pages/profil/profil_page.dart';
import 'main_layout.dart';

/// Shell utama setelah login: bottom nav + 5 halaman tab.
class MainShell extends StatelessWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      initialIndex: initialIndex,
      pages: const [
        BerandaPage(),
        LokasiPage(),
        PendaftaranPage(),
        RiwayatPage(),
        ProfilPage(),
      ],
    );
  }
}
