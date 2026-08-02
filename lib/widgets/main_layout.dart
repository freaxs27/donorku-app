import 'package:flutter/material.dart';
import '../core/locale/app_strings.dart';
import '../core/theme/app_tema.dart';
import '../theme/app_theme.dart';
import 'theme_sync.dart';

class MainLayoutScope extends InheritedWidget {
  final void Function(int index) pindahTab;

  const MainLayoutScope({
    super.key,
    required this.pindahTab,
    required super.child,
  });

  static MainLayoutScope? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainLayoutScope>();
  }

  @override
  bool updateShouldNotify(MainLayoutScope oldWidget) => pindahTab != oldWidget.pindahTab;
}

//
// MainLayout(
//   pages: [
//     DashboardPage(),   // Beranda
//     LocationPage(),    // Lokasi
//     DonorFlowPage(),   // Daftar
//     HistoryPage(),     // Riwayat
//     ProfilePage(),     // Profil
//   ],
// )
class MainLayout extends StatefulWidget {
  final List<Widget> pages;

  final int initialIndex;

  const MainLayout({
    super.key,
    required this.pages,
    this.initialIndex = 0,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late int _currentIndex;
  late final List<GlobalKey<NavigatorState>> _navigatorKeys;

  static const List<String> _navAssetPaths = [
    'assets/icons/nav/beranda.png',
    'assets/icons/nav/lokasi.png',
    'assets/icons/nav/pendaftaran.png',
    'assets/icons/nav/riwayat.png',
    'assets/icons/nav/profil.png',
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _navigatorKeys = List.generate(widget.pages.length, (_) => GlobalKey<NavigatorState>());
  }

  void _onTapNav(int index) {
    if (index != _currentIndex) {
      _navigatorKeys[index].currentState?.popUntil((route) => route.isFirst);
    }
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: ThemeController.instance,
      builder: (context, _) {
        final s = AppStrings.of(context);
        final navLabels = [
          s.navBeranda,
          s.navLokasi,
          s.navDaftar,
          s.navRiwayat,
          s.navProfil,
        ];

        assert(
          widget.pages.length == _navAssetPaths.length,
          'Jumlah halaman (${widget.pages.length}) harus sama dengan jumlah item nav (${_navAssetPaths.length})',
        );

        return MainLayoutScope(
          pindahTab: _onTapNav,
          child: Scaffold(
            backgroundColor: AppColors.of(context).background,
            body: IndexedStack(
              index: _currentIndex,
              children: List.generate(widget.pages.length, (i) {
                return Navigator(
                  key: _navigatorKeys[i],
                  onGenerateRoute: (settings) => AppPageRoute(
                    builder: (context) => widget.pages[i],
                  ),
                );
              }),
            ),
            bottomNavigationBar: _buildBottomNav(context, navLabels),
          ),
        );
      },
    );
  }

  Widget _buildBottomNav(BuildContext context, List<String> navLabels) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navAssetPaths.length, (index) {
              final bool isActive = index == _currentIndex;
              return _NavItem(
                assetPath: _navAssetPaths[index],
                label: navLabels[index],
                isActive: isActive,
                onTap: () => _onTapNav(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String assetPath;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.assetPath,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeBg = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = AppColors.of(context).textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 68, 
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                isActive ? Colors.white : inactiveColor,
                BlendMode.srcIn,
              ),
              child: Image.asset(
                assetPath,
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                color: isActive ? Colors.white : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
