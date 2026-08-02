import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../theme/app_theme.dart';
import '../../../core/locale/app_strings.dart';
import '../../../core/validators/app_validators.dart';
import '../../../model/data_register.dart';
import 'foto_ktp_page.dart';

// (R-001).
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noHpController = TextEditingController();
  final TextEditingController _kotaController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureKonfirmasi = true;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _noHpController.dispose();
    _kotaController.dispose();
    _passwordController.dispose();
    _konfirmasiController.dispose();
    super.dispose();
  }

  void _lanjutkan() {
    final s = AppStrings.of(context);
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final noHp = _noHpController.text.trim();
    final kota = _kotaController.text.trim();
    final password = _passwordController.text;
    final konfirmasi = _konfirmasiController.text;

    if (nama.isEmpty || email.isEmpty || noHp.isEmpty || kota.isEmpty || password.isEmpty) {
      _tampilkanPesan(s.allFieldsRequired);
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _tampilkanPesan(s.invalidEmailFormat);
      return;
    }
    final errPass = AppValidators.password(password);
    if (errPass != null) {
      _tampilkanPesan(errPass);
      return;
    }
    final errKonfirm = AppValidators.passwordConfirm(password, konfirmasi);
    if (errKonfirm != null) {
      _tampilkanPesan(errKonfirm);
      return;
    }

    final data = DataRegister(
      namaLengkap: nama,
      email: email,
      noHp: noHp,
      kota: kota,
      password: password,
      passwordConfirm: konfirmasi,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => FotoKtpPage(data: data)),
    );
  }

  void _tampilkanPesan(String pesan) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(pesan)));
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(s.createAccountTitle, style: AppTextStyles.heading),
            ),
            const SizedBox(height: 20),

            Text(s.fullNameLabel, style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: InputDecoration(hintText: s.fullNameHint),
            ),
            const SizedBox(height: 16),

            Text(s.emailLabel, style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(hintText: s.emailHint),
            ),
            const SizedBox(height: 16),

            Text(s.phoneLabel, style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _noHpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(hintText: s.phoneHint),
            ),
            const SizedBox(height: 16),

            Text(s.cityLabel, style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _kotaController,
              decoration: InputDecoration(hintText: s.cityHint),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            Text(s.confirmPasswordLabel, style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _konfirmasiController,
              obscureText: _obscureKonfirmasi,
              decoration: InputDecoration(
                hintText: s.confirmPasswordHint,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureKonfirmasi
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () {
                    setState(() => _obscureKonfirmasi = !_obscureKonfirmasi);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _lanjutkan,
              child: Text(s.nextButton),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(child: Divider(color: Colors.black26)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(s.orDivider, style: AppTextStyles.caption),
                ),
                const Expanded(child: Divider(color: Colors.black26)),
              ],
            ),
            const SizedBox(height: 20),

            OutlinedButton.icon(
              onPressed: () {
                // TODO: integrasi daftar dengan Google
              },
              icon: Image.asset(
                'assets/icons/social/google.png',
                width: 20,
                height: 20,
              ),
              label: Text(s.registerWithGoogle),
            ),
            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {
                // TODO: integrasi daftar dengan Facebook
              },
              icon: Image.asset(
                'assets/icons/social/facebook.png',
                width: 20,
                height: 20,
              ),
              label: Text(s.registerWithFacebook),
            ),
            const SizedBox(height: 16),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  children: [
                    TextSpan(text: s.haveAccountPrompt),
                    TextSpan(
                      text: s.loginHereLink,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
