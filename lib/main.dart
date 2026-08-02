import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/auth/session_service.dart';
import 'services/core/api_client.dart';
import 'pages/auth/login_page.dart';
import 'widgets/main_shell.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.onUnauthorized = () {
    _navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  };
  runApp(const DonorkuApp());
}

class DonorkuApp extends StatelessWidget {
  const DonorkuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donorku',
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const _AuthGate(),
    );
  }
}

/// Cek sesi di startup: sudah login → MainShell, belum → LoginPage.
class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late final Future<bool> _cekSesi = SessionService.sudahLogin();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _cekSesi,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.data == true) {
          return const MainShell();
        }

        return const LoginPage();
      },
    );
  }
}
