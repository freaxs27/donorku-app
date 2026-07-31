import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'pages/auth/login_page.dart';

void main() {
  runApp(const DonorkuApp());
}

class DonorkuApp extends StatelessWidget {
  const DonorkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donorku',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // Entry point aplikasi sekarang ke Login, bukan langsung ke Beranda.
      // MainLayout (bottom nav) baru muncul setelah user berhasil login.
      home: const LoginPage(), 
    );
  }
}