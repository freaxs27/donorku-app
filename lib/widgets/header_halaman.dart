import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Header standar untuk halaman-halaman utama (Lokasi, Daftar, Profil, dst.),
/// supaya judulnya selalu SAMA font & posisinya (center) di semua halaman.
///
/// - [leadingIcon] & [onTapLeading]: opsional, buat icon di kiri (misal
///   panah back di halaman Lokasi). Kalau tidak diisi, dikasih ruang
///   kosong sebesar icon supaya judul tetap center sempurna.
/// - [trailing]: opsional, buat widget di kanan (misal icon lampu di
///   halaman Daftar). Kalau tidak diisi, juga dikasih ruang kosong
///   penyeimbang.
class HeaderHalaman extends StatelessWidget {
  final String judul;
  final IconData? leadingIcon;
  final VoidCallback? onTapLeading;
  final Widget? trailing;

  const HeaderHalaman({
    super.key,
    required this.judul,
    this.leadingIcon,
    this.onTapLeading,
    this.trailing,
  });

  static const double _lebarSisi = 24; // lebar penyeimbang kiri/kanan

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _lebarSisi,
          child: leadingIcon != null
              ? GestureDetector(
                  onTap: onTapLeading,
                  child: Icon(leadingIcon, color: AppColors.of(context).textPrimary),
                )
              : null,
        ),
        Expanded(
          child: Text(
            judul,
            textAlign: TextAlign.center,
            style: AppTextStyles.subheading(context),
          ),
        ),
        SizedBox(width: _lebarSisi, child: trailing),
      ],
    );
  }
}