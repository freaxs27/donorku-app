import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../theme/app_theme.dart';
import '../../core/locale/app_strings.dart';
import '../../widgets/main_shell.dart';
import '../../services/auth/auth_service.dart';
import '../../services/core/api_exception.dart';
import '../../services/auth/session_service.dart';
import 'register/register_page.dart';
import 'lupa_password/lupa_password_page.dart';

// (L-001).
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  bool _obscurePassword = true;
  bool _sedangLogin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _tampilkanPesan(AppStrings.of(context).emailPasswordRequired);
      return;
    }

    setState(() => _sedangLogin = true);

    try {
      final hasil = await _authService.login(email: email, password: password);

      final pendonor = hasil['pendonor'] as Map<String, dynamic>;
      await SessionService.simpanSesi(
        token: hasil['access_token'] as String,
        idPendonor: pendonor['id_pendonor'] as int,
        namaLengkap: pendonor['nama_lengkap'] as String,
        email: pendonor['email'] as String,
      );

      if (!mounted) return;
      _goToDashboard();
    } on ApiException catch (e) {
      _tampilkanPesan(e.message);
    } catch (e) {
      _tampilkanPesan(AppStrings.of(context).unexpectedError);
    } finally {
      if (mounted) setState(() => _sedangLogin = false);
    }
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  void _goToDashboard() {
    Navigator.of(context, rootNavigator: true).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainShell()),
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
    final s = AppStrings.of(context);
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

              // Logo Donorku
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 110,
                ),
              ),
              const SizedBox(height: 24),

              Text(
                s.loginTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading,
              ),
              const SizedBox(height: 24),

              // Email
              Text(s.emailLabel, style: AppTextStyles.body),
              const SizedBox(height: 8),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(hintText: s.emailHint),
              ),
              const SizedBox(height: 16),

              // Password
              Text(s.passwordLabel, style: AppTextStyles.body),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: s.passwordHint,
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
                  child: Text(
                    s.forgotPasswordLink,
                    style: const TextStyle(
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
                      onPressed: _sedangLogin ? null : _login,
                      child: _sedangLogin
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : Text(s.signInButton),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        _emailController.clear();
                        _passwordController.clear();
                      },
                      child: Text(s.resetButton),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Link ke Register
              Center(
                child: RichText(
                  text: TextSpan(
                    style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                    children: [
                      TextSpan(text: s.noAccountPrompt),
                      TextSpan(
                        text: s.createAccountLink,
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
