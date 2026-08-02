import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'theme/app_theme.dart';
import 'services/auth/session_service.dart';
import 'services/core/api_client.dart';
import 'core/locale/app_bahasa.dart';
import 'core/locale/app_strings.dart';
import 'core/theme/app_tema.dart';
import 'pages/auth/login_page.dart';
import 'widgets/main_shell.dart';
import 'widgets/theme_sync.dart';

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait([
    LocaleController.instance.muat(),
    ThemeController.instance.muat(),
  ]);
  ApiClient.onUnauthorized = () {
    _navigatorKey.currentState?.pushAndRemoveUntil(
      AppPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  };
  runApp(const DonorkuApp());
}

class DonorkuApp extends StatefulWidget {
  const DonorkuApp({super.key});

  @override
  State<DonorkuApp> createState() => _DonorkuAppState();
}

class _DonorkuAppState extends State<DonorkuApp> with WidgetsBindingObserver {
  late final Listenable _appListenables;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _appListenables = Listenable.merge([
      LocaleController.instance,
      ThemeController.instance,
    ]);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    ThemeController.instance.padaPerubahanPlatformBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _appListenables,
      builder: (context, _) {
        return MaterialApp(
          title: 'Donorku',
          navigatorKey: _navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeController.instance.themeMode,
          locale: LocaleController.instance.locale,
          supportedLocales: AppBahasa.values.map((b) => b.locale).toList(),
          localizationsDelegates: const [
            AppStringsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const _AuthGate(),
        );
      },
    );
  }
}

class _AuthGate extends StatefulWidget {
  const _AuthGate();

  @override
  State<_AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<_AuthGate> {
  late final Future<bool> _cekSesi = SessionService.sudahLogin();

  @override
  Widget build(BuildContext context) {
    return ThemeSync(
      child: FutureBuilder<bool>(
        future: _cekSesi,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Scaffold(
              backgroundColor: AppColors.of(context).background,
              body: const Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.data == true) {
            return const MainShell();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
