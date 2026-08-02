import 'package:flutter/material.dart';
import '../core/theme/app_tema.dart';

/// Membungkus halaman agar ikut rebuild saat [ThemeController] berubah.
/// Warna diambil via [AppColors.of] → [ThemeExtension], jadi ikut Theme MaterialApp.
class ThemeSync extends StatelessWidget {
  const ThemeSync({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) => child,
    );
  }
}

/// [MaterialPageRoute] yang selalu dibungkus [ThemeSync].
class AppPageRoute<T> extends MaterialPageRoute<T> {
  AppPageRoute({
    required WidgetBuilder builder,
    super.settings,
    super.fullscreenDialog,
    super.maintainState,
  }) : super(
          builder: (context) => ThemeSync(child: Builder(builder: builder)),
        );
}
