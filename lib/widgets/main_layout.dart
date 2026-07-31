import 'package:flutter/material.dart';
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

  static const List<_NavItemData> _navItems = [
    _NavItemData(assetPath: 'assets/icons/nav/beranda.png', label: 'Beranda'),
    _NavItemData(assetPath: 'assets/icons/nav/lokasi.png', label: 'Lokasi'),
    _NavItemData(assetPath: 'assets/icons/nav/pendaftaran.png', label: 'Daftar'),
    _NavItemData(assetPath: 'assets/icons/nav/riwayat.png', label: 'Riwayat'),
    _NavItemData(assetPath: 'assets/icons/nav/profil.png', label: 'Profil'),
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
    assert(
      widget.pages.length == _navItems.length,
      'Jumlah halaman (${widget.pages.length}) harus sama dengan jumlah item nav (${_navItems.length})',
    );

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: List.generate(widget.pages.length, (i) {
          return Navigator(
            key: _navigatorKeys[i],
            onGenerateRoute: (settings) => MaterialPageRoute(
              builder: (context) => widget.pages[i],
            ),
          );
        }),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
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
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final bool isActive = index == _currentIndex;
              return _NavItem(
                data: item,
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

class _NavItemData {
  final String assetPath;
  final String label;

  const _NavItemData({
    required this.assetPath,
    required this.label,
  });
}

class _NavItem extends StatelessWidget {
  final _NavItemData data;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.data,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color activeBg = Theme.of(context).colorScheme.primary;
    final Color inactiveColor = Colors.black87;

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
                data.assetPath,
                width: 22,
                height: 22,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              data.label,
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