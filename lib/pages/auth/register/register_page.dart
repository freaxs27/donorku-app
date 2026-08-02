import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../../../theme/app_theme.dart';
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
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final noHp = _noHpController.text.trim();
    final kota = _kotaController.text.trim();
    final password = _passwordController.text;
    final konfirmasi = _konfirmasiController.text;

    if (nama.isEmpty || email.isEmpty || noHp.isEmpty || kota.isEmpty || password.isEmpty) {
      _tampilkanPesan('Semua field wajib diisi');
      return;
    }
    if (!email.contains('@') || !email.contains('.')) {
      _tampilkanPesan('Format email tidak valid');
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
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: AppColors.textPrimary),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppDimens.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text('Buat Akunmu', style: AppTextStyles.heading),
            ),
            const SizedBox(height: 20),

            const Text('Nama Lengkap', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _namaController,
              decoration: const InputDecoration(hintText: 'Masukan nama lengkap'),
            ),
            const SizedBox(height: 16),

            const Text('Email', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'Masukan email'),
            ),
            const SizedBox(height: 16),

            const Text('No HP', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _noHpController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: 'Masukan no hp'),
            ),
            const SizedBox(height: 16),

            const Text('Kota', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _kotaController,
              decoration: const InputDecoration(hintText: 'Masukan kota asal'),
            ),
            const SizedBox(height: 16),

            const Text('Password', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
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
            const SizedBox(height: 16),

            const Text('Konfirmasi Password', style: AppTextStyles.body),
            const SizedBox(height: 8),
            TextField(
              controller: _konfirmasiController,
              obscureText: _obscureKonfirmasi,
              decoration: InputDecoration(
                hintText: 'Masukan kembali password',
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
              child: const Text('Selanjutnya'),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                const Expanded(child: Divider(color: Colors.black26)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Atau', style: AppTextStyles.caption),
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
              label: const Text('Daftar dengan Google'),
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
              label: const Text('Daftar dengan Facebook'),
            ),
            const SizedBox(height: 16),

            Center(
              child: RichText(
                text: TextSpan(
                  style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
                  children: [
                    const TextSpan(text: 'Sudah punya akun? '),
                    TextSpan(
                      text: 'login disini',
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