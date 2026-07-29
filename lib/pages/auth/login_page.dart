import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../theme/app_theme.dart';
import '../../widgets/main_layout.dart';
import '../beranda/beranda_page.dart';
import '../lokasi/lokasi_page.dart';
import '../pendaftaran/pendaftaran_page.dart';
import '../riwayat/riwayat_page.dart';
import '../profil/profil_page.dart';
import 'register/register_page.dart';
import 'lupa_password/lupa_password_page.dart';

/// Halaman Login (L-001).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscurePassword = true;

  void _goToDashboard() {
    // Sementara: langsung ke MainLayout tanpa validasi/backend.
    // Nanti di sini ditambahkan logic autentikasi yang sesungguhnya.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainLayout(
          pages: [
            BerandaPage(),
            LokasiPage(),
            PendaftaranPage(),
            RiwayatPage(),
            ProfilPage(),
          ],
        ),
      ),
    );
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }

  void _goToForgotPassword() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const LupaPasswordPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.paddingL,
            vertical: AppDimens.paddingL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 110,
                ),
              ),
              const SizedBox(height: 24),

              const Text(
                'Login ke akunmu',
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 24),

              // Email
              const Text('Email', style: AppTextStyles.body),
              const SizedBox(height: 8),
              const TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: 'Masukan email'),
              ),
              const SizedBox(height: 16),

              // Password
              const Text('Password', style: AppTextStyles.body),
              const SizedBox(height: 8),
              TextField(
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: 'Masukan password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Lupa password
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _goToForgotPassword,
                  child: const Text(
                    'Lupa password?',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Masuk & Reset
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _goToDashboard,
                      child: const Text('Masuk'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                      },
                      child: const Text('Reset'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Divider "Atau"
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('Atau', style: AppTextStyles.caption),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 20),

              // Login dengan Google
              OutlinedButton.icon(
                onPressed: () {
                },
                icon: Image.asset(
                  'assets/icons/social/google.png',
                  width: 20,
                  height: 20,
                ),
                label: const Text('Login dengan Google'),
              ),
              const SizedBox(height: 12),

              // Login dengan Facebook
              OutlinedButton.icon(
                onPressed: () {
                },
                icon: Image.asset(
                  'assets/icons/social/facebook.png',
                  width: 20,
                  height: 20,
                ),
                label: const Text('Login dengan Facebook'),
              ),
              const SizedBox(height: 20),

              // Link ke Register
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    children: [
                      const TextSpan(text: 'Tidak punya akun? '),
                      TextSpan(
                        text: 'buat disini',
                        style: const TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: (TapGestureRecognizer()
                          ..onTap = _goToRegister),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}