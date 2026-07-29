import 'package:flutter/material.dart';

/// MainLayout adalah kerangka utama aplikasi Donorku.
/// Semua halaman yang punya bottom navigation bar (Beranda, Lokasi,
/// Daftar, Riwayat, Profil) akan "dibungkus" oleh widget ini.
///
/// Cara pakai nanti (contoh, JANGAN dijalankan dulu sebelum halaman lain
/// dibuat):
///
/// MainLayout(
///   pages: [
///     DashboardPage(),   // Beranda
///     LocationPage(),    // Lokasi
///     DonorFlowPage(),   // Daftar
///     HistoryPage(),     // Riwayat
///     ProfilePage(),     // Profil
///   ],
/// )
class MainLayout extends StatefulWidget {
  /// Daftar halaman untuk tiap tab, urutannya harus sama dengan urutan
  /// item di bottom navigation bar.
  final List<Widget> pages;

  /// Index tab yang aktif saat pertama kali dibuka (default: tab pertama).
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
  }

  void _onTapNav(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.pages.length == _navItems.length,
      'Jumlah halaman (${widget.pages.length}) harus sama dengan jumlah item nav (${_navItems.length})',
    );

    return Scaffold(
      // IndexedStack menjaga state tiap halaman tetap hidup walau
      // berpindah tab (tidak seperti Navigator.push yang membuat
      // instance baru tiap kali).
      body: IndexedStack(
        index: _currentIndex,
        children: widget.pages,
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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

    // Item AKTIF: kotak merah rounded membungkus icon + label, keduanya putih.
    // Item TIDAK aktif: hanya icon + label warna hitam, tanpa background.
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 68, // lebar tetap, sama untuk semua item (ikut label terpanjang: "Riwayat")
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColorFiltered(
              // Icon PNG asli warnanya hitam polos (dari Figma export).
              // ColorFiltered dipakai supaya bisa "dicat ulang" jadi putih
              // saat aktif, tanpa perlu file gambar terpisah untuk tiap warna.
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