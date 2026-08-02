import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'app_bahasa.dart';

/// String UI aplikasi. Ambil lewat [AppStrings.of] agar ikut rebuild
/// saat bahasa diganti di Pengaturan.
class AppStrings {
  AppStrings._(this._b);

  final AppBahasa _b;

  bool get _en => _b == AppBahasa.english;
  AppBahasa get bahasa => _b;

  static AppStrings of(BuildContext context) {
    final s = Localizations.of<AppStrings>(context, AppStrings);
    assert(s != null, 'AppStrings tidak ditemukan. Pastikan delegate terpasang di MaterialApp.');
    return s!;
  }

  /// Untuk kode tanpa BuildContext (validator, service helper).
  static AppStrings get current =>
      AppStrings._(LocaleController.instance.bahasa);

  static AppStrings dariBahasa(AppBahasa b) => AppStrings._(b);

  // ---- Umum ----
  String get appTitle => 'Donorku';
  String get tryAgain => _en ? 'Try again' : 'Coba lagi';
  String get tryAgainButton => _en ? 'Try Again' : 'Coba Lagi';
  String get nextButton => _en ? 'Next' : 'Selanjutnya';
  String get cancelButton => _en ? 'Cancel' : 'Batal';
  String get saveButton => _en ? 'Save' : 'Simpan';
  String get yesLabel => _en ? 'Yes' : 'Ya';
  String get noLabel => _en ? 'No' : 'Tidak';
  String get orDivider => _en ? 'Or' : 'Atau';
  String get resetButton => 'Reset';
  String get unexpectedError =>
      _en ? 'An unexpected error occurred, please try again' : 'Terjadi kesalahan tak terduga, coba lagi';
  String get unexpectedErrorDot =>
      _en ? 'An unexpected error occurred, please try again.' : 'Terjadi kesalahan tak terduga, coba lagi.';
  String get errorTryAgain =>
      _en ? 'An error occurred, please try again.' : 'Terjadi kesalahan, coba lagi.';
  String get loadDataFailed =>
      _en ? 'Failed to load data, please try again' : 'Gagal memuat data, coba lagi';

  // ---- Nav ----
  String get navBeranda => _en ? 'Home' : 'Beranda';
  String get navLokasi => _en ? 'Location' : 'Lokasi';
  String get navDaftar => _en ? 'Donate' : 'Daftar';
  String get navRiwayat => _en ? 'History' : 'Riwayat';
  String get navProfil => _en ? 'Profile' : 'Profil';

  // ---- Auth umum ----
  String get emailLabel => 'Email';
  String get emailHint => _en ? 'Enter email' : 'Masukan email';
  String get passwordLabel => 'Password';
  String get passwordHint => _en ? 'Enter password' : 'Masukan password';
  String get confirmPasswordLabel =>
      _en ? 'Confirm Password' : 'Konfirmasi Password';
  String get confirmPasswordHint =>
      _en ? 'Re-enter password' : 'Masukan kembali password';
  String get fullNameLabel => _en ? 'Full Name' : 'Nama Lengkap';
  String get fullNameHint => _en ? 'Enter full name' : 'Masukan nama lengkap';
  String get phoneLabel => _en ? 'Phone Number' : 'No HP';
  String get phoneHint => _en ? 'Enter phone number' : 'Masukan no hp';
  String get phoneProfilLabel => _en ? 'Phone Number' : 'No Telepon';
  String get cityLabel => _en ? 'City' : 'Kota';
  String get cityHint => _en ? 'Enter city of origin' : 'Masukan kota asal';
  String get nameLabel => _en ? 'Name' : 'Nama';
  String get addressLabel => _en ? 'Address' : 'Alamat';
  String get bloodTypeLabel => _en ? 'Blood Type' : 'Golongan Darah';
  String get bloodTypeShort => _en ? 'Blood Type' : 'Goldar';
  String get bloodTypeShortDot => _en ? 'Blood Type' : 'Gol. Darah';
  String get occupationLabel => _en ? 'Occupation' : 'Profesi';
  String get nikLabel => 'NIK';
  String get dobLabel => _en ? 'Date of Birth' : 'Tanggal Lahir';
  String get dobTtlLabel => 'TTL';
  String get haveAccountPrompt =>
      _en ? "Already have an account? " : 'Sudah punya akun? ';
  String get loginHereLink => _en ? 'log in here' : 'login disini';
  String get noAccountPrompt =>
      _en ? "Don't have an account? " : 'Tidak punya akun? ';
  String get createAccountLink => _en ? 'create one here' : 'buat disini';
  String get backToLogin => _en ? 'Back to login' : 'Kembali ke login';
  String get allFieldsRequired =>
      _en ? 'All fields are required' : 'Semua field wajib diisi';
  String get invalidEmailFormat =>
      _en ? 'Invalid email format' : 'Format email tidak valid';
  String get emailPasswordRequired =>
      _en ? 'Email and password are required' : 'Email dan password wajib diisi';
  String get passwordRequired =>
      _en ? 'Password is required' : 'Password wajib diisi';
  String passwordMinLength(int n) => _en
      ? 'Password must be at least $n characters'
      : 'Password minimal $n karakter';
  String get passwordConfirmMismatch =>
      _en ? 'Password confirmation does not match' : 'Konfirmasi password tidak cocok';

  // ---- Login ----
  String get loginTitle => _en ? 'Log in to your account' : 'Login ke akunmu';
  String get forgotPasswordLink => _en ? 'Forgot password?' : 'Lupa password?';
  String get signInButton => _en ? 'Sign In' : 'Masuk';
  String get loginWithGoogle => _en ? 'Sign in with Google' : 'Login dengan Google';
  String get loginWithFacebook =>
      _en ? 'Sign in with Facebook' : 'Login dengan Facebook';

  // ---- Register ----
  String get createAccountTitle => _en ? 'Create Your Account' : 'Buat Akunmu';
  String get createAccountButton => _en ? 'Create Account' : 'Buat Akun';
  String get registerWithGoogle =>
      _en ? 'Sign up with Google' : 'Daftar dengan Google';
  String get registerWithFacebook =>
      _en ? 'Sign up with Facebook' : 'Daftar dengan Facebook';
  String get photoKtpTitle =>
      _en ? 'Take a photo of your KTP or e-KTP' : 'Fotokan KTPmu atau e-ktp';
  String get selfieTitle => _en ? 'Selfie' : 'Foto Diri';
  String get accountCreatedSuccess =>
      _en ? 'Account created successfully' : 'Berhasil membuat akun';
  String get nikMustBe16 =>
      _en ? 'NIK must be 16 digits' : 'NIK harus 16 digit angka';
  String get dobFormatUnrecognized => _en
      ? 'Date of birth format not recognized, edit manually (e.g. 28-06-2006)'
      : 'Format TTL tidak dikenali, coba edit manual (contoh: 28-06-2006)';
  String get completeKtpScanData =>
      _en ? 'Complete all KTP scan data first' : 'Lengkapi semua data hasil scan KTP dulu';
  String get bloodTypeFormatInvalid => _en
      ? 'Blood type must end with + or - (e.g. O+, AB-)'
      : 'Golongan darah harus diakhiri + atau - (contoh: O+, AB-)';
  String get ktpDataIncomplete => _en
      ? 'KTP data incomplete, please repeat from the previous step'
      : 'Data KTP belum lengkap, silakan ulangi dari langkah sebelumnya';

  // ---- Lupa password ----
  String get forgotPasswordTitle => _en ? 'Forgot Password' : 'Lupa Password';
  String get forgotPasswordSubtitle => _en
      ? 'Enter your email to reset your password'
      : 'Masukan emailmu untuk mereset password';
  String get enterValidEmail =>
      _en ? 'Enter a valid email' : 'Masukkan email yang valid';
  String get verifyEmailTitle => _en ? 'Email Verification' : 'Verifikasi Email';
  String verifyEmailSubtitle(String email) => _en
      ? 'We sent an email to $email\nEnter the code from the email'
      : 'Kami telah mengirim email kepada $email\nMasukan kode yang ada di email';
  String get verifyButton => _en ? 'Verify' : 'Verifikasi';
  String get noCodePrompt =>
      _en ? "Didn't receive the code? " : 'Belum mendapatkan kode? ';
  String get sendingLink => _en ? 'Sending...' : 'Mengirim...';
  String get resendLink => _en ? 'Resend' : 'Kirim ulang';
  String get otpIncomplete =>
      _en ? 'Enter the complete 6-digit OTP code' : 'Masukkan 6 digit kode OTP lengkap';
  String get resendCodeFailed =>
      _en ? 'Failed to resend code, please try again' : 'Gagal mengirim ulang kode, coba lagi';
  String get setNewPasswordTitle =>
      _en ? 'Set New Password' : 'Atur Password Baru';
  String get setNewPasswordSubtitle =>
      _en ? 'Enter your new password' : 'Masukan password yang baru';
  String get resetPasswordButton =>
      _en ? 'Reset Password' : 'Atur Ulang Password';
  String get passwordResetSuccess =>
      _en ? 'Password updated successfully' : 'Berhasil mengatur password';

  // ---- Pengaturan ----
  String get pengaturan => _en ? 'Settings' : 'Pengaturan';
  String get notifikasi => _en ? 'Notifications' : 'Notifikasi';
  String get nyalakanNotifikasi =>
      _en ? 'Enable Notifications' : 'Nyalakan Notifikasi';
  String get notifikasiEmail => _en ? 'Email Notifications' : 'Notifikasi Email';
  String get sms => 'SMS';
  String get aplikasi => _en ? 'Application' : 'Aplikasi';
  String get pilihBahasa => _en ? 'Language' : 'Pilih Bahasa';
  String get sesuaikanTema => _en ? 'Theme' : 'Sesuaikan Tema';
  String get pengaturanPrivasi =>
      _en ? 'Privacy Settings' : 'Pengaturan Privasi';
  String get tentangKami => _en ? 'About Us' : 'Tentang Kami';
  String get tentangDonorKu => _en ? 'About Donorku' : 'Tentang Donor Ku';
  String get bantuan => _en ? 'Help' : 'Bantuan';
  String get syaratKetentuan =>
      _en ? 'Terms & Conditions' : 'Syarat & Ketentuan';
  String get kebijakanPrivasi => _en ? 'Privacy Policy' : 'Kebijakan Privasi';
  String get akun => _en ? 'Account' : 'Akun';
  String get keluar => _en ? 'Log Out' : 'Keluar';
  String get hapusAkun => _en ? 'Delete Account' : 'Hapus Akun';
  String get judulPilihBahasa => _en ? 'Language' : 'Pilih Bahasa';
  String get deskripsiPilihBahasa => _en
      ? 'Choose the language used throughout the app.'
      : 'Pilih bahasa yang digunakan di seluruh aplikasi.';
  String get bahasaBerhasilDiubah =>
      _en ? 'Language updated' : 'Bahasa berhasil diubah';

  // ---- Beranda ----
  String greetingHello(String name) => _en ? 'Hello, $name' : 'Halo, $name';
  String get chatRezaTitle =>
      _en ? 'Talk to Reza Chatbot' : 'Bicara Dengan Reza Chatbot';
  String get chatRezaSubtitle => _en
      ? 'Ask Reza about blood donation'
      : 'Silahkan bertanya kepada Reza seputar donor darah';
  String get chatAdminTitle => _en ? 'Talk to Admin' : 'Bicara Dengan Admin';
  String get chatAdminSubtitle => _en
      ? 'Connect directly with support staff'
      : 'Terhubung langsung dengan staf dukungan';
  String get startDonatingTitle =>
      _en ? 'Start Donating Your Blood' : 'Mulai Donorkan Darahmu';
  String get startDonatingSubtitle => _en
      ? 'Donate at the nearest blood drive to help those in need'
      : 'Donorkan di posko donor terdekat untuk membantu orang yang membutuhkan';
  String get registerDonorButton =>
      _en ? 'Register as Donor' : 'Daftar Donor';
  String get youHaveDonatedTitle =>
      _en ? 'You Have Donated' : 'Anda Sudah Donor';
  String get totalDonations => _en ? 'Total Donations' : 'Total Donasi';
  String get mlBlood => _en ? 'ml Blood' : 'ml Darah';
  String get canDonateNow => _en ? 'You Can Donate Now' : 'Anda Sudah Bisa Donor';
  String get canDonateAgain => _en ? 'Can Donate Again' : 'Dapat Donor Kembali';
  String get nowExclaim => _en ? 'Now!' : 'Sekarang!';
  String get nowLabel => _en ? 'Now' : 'Sekarang';
  String get availableLocationsTitle =>
      _en ? 'Available Blood Donation Locations' : 'Lokasi Tersedia Donor Darah';
  String get openDonorStatus =>
      _en ? 'Blood Donation Open' : 'Open Donor Darah';
  String scheduleQuota(String jamMulai, String jamSelesai, int kuota) => _en
      ? '$jamMulai - $jamSelesai  $kuota slots left'
      : '$jamMulai - $jamSelesai  Sisa $kuota kuota';
  String get viewLocationDetails =>
      _en ? 'View Location Details' : 'Cek Detail Lokasi';
  String get writeQuestionHint =>
      _en ? 'Write your question' : 'Tulis Pertanyaanmu';
  String get notificationsTitle => _en ? 'Notifications' : 'Notifikasi';
  String get noNotifications =>
      _en ? 'No notifications yet' : 'Belum ada notifikasi';

  // ---- Lokasi ----
  String get locationTitle => _en ? 'Location' : 'Lokasi';
  String get loadLocationFailed => _en
      ? 'Failed to load location data, please try again'
      : 'Gagal memuat data lokasi, coba lagi';
  String get searchHint => _en ? 'Search Here' : 'Cari Disini';

  // ---- Pendaftaran / tips ----
  String get donorRulesTitle =>
      _en ? 'Donor Rules and Tips' : 'Aturan dan Tips Donor';
  String get rulesBeforeDonation =>
      _en ? 'Rules before donating blood:' : 'Aturan sebelum donor darah :';
  String get ruleAge => _en ? 'Age' : 'Usia';
  String get ruleAgeDetail => _en
      ? 'No age limit, as long as health is normal with no blood-related disease history'
      : 'Tidak memiliki batasan usia, asalkan kondisi kesehatan normal dan tidak punya riwayat penyakit berhubungan dengan darah';
  String get ruleWeight => _en ? 'Body Weight' : 'Berat Badan';
  String get ruleWeightDetail => _en ? 'Minimum 45 kg' : 'Minimal 45 kg';
  String get rulePhysical => _en ? 'Physical Condition' : 'Kondisi Fisik';
  String get rulePhysicalDetail1 =>
      _en ? 'Physically and mentally healthy' : 'Sehat jasmani & rohani';
  String get rulePhysicalDetail2 => _en
      ? 'Not currently feverish, with flu, or ill'
      : 'Tidak sedang demam, flu, atau sakit';
  String get ruleBloodPressure => _en ? 'Blood Pressure' : 'Tekanan Darah';
  String get ruleBpSystolic =>
      _en ? 'Systolic: 100-170 mmHg' : 'Sistole: 100-170 mmHg';
  String get ruleBpDiastolic =>
      _en ? 'Diastolic: 70-100 mmHg' : 'Diastole: 70-100 mmHg';
  String get ruleHemoglobin =>
      _en ? 'Hemoglobin Level (Hb)' : 'Kadar Hemoglobin (Hb)';
  String get ruleHbMale => _en ? 'Male: ≥ 12.5 g/dL' : 'Pria: ≥ 12,5 g/dL';
  String get ruleHbFemale => _en ? 'Female: ≥ 12.0 g/dL' : 'Wanita: ≥ 12,0 g/dL';
  String get tipsBeforeDonation =>
      _en ? 'Tips before donating blood:' : 'Tips sebelum donor darah :';
  String get tipSleep => _en ? 'Get Enough Sleep' : 'Tidur Cukup';
  String get tipSleepDetail1 => _en ? 'At least 6-8 hours' : 'Minimal 6-8 jam';
  String get tipSleepDetail2 => _en
      ? 'Avoid staying up late before donating'
      : 'Hindari begadang sebelum donor';
  String get tipEat => _en ? 'Eat Before Donating' : 'Makan Sebelum Donor';
  String get tipEatDetail1 =>
      _en ? 'Eat 3-4 hours beforehand' : 'Makan 3-4 jam sebelumnya';
  String get tipEatDetail2 =>
      _en ? 'Choose light, nutritious food' : 'Pilih makanan ringan & bergizi';
  String get tipEatDetail3 =>
      _en ? 'Avoid high-fat food' : 'Hindari makanan berlemak tinggi';
  String get tipHydration => _en ? 'Stay Hydrated' : 'Cukupi Asupan Cairan';
  String get tipHydrationDetail1 =>
      _en ? 'Drink 2-3 glasses of water' : 'Minum air putih 2-3 gelas';
  String get tipHydrationDetail2 => _en
      ? 'Avoid alcohol at least 24 hours before'
      : 'Hindari alkohol minimal 24 jam sebelumnya';
  String get tipSmoking => _en ? 'Avoid Smoking' : 'Hindari Rokok';
  String get tipSmokingDetail1 => _en
      ? 'No smoking 1 hour before donating'
      : 'Tidak merokok 1 jam sebelum donor';
  String get tipSmokingDetail2 => _en
      ? 'No smoking 1 hour after donating'
      : 'Tidak merokok 1 jam setelah donor';
  String get tipHealthy =>
      _en ? 'Ensure You Are Healthy' : 'Pastikan Kondisi Tubuh Sehat';
  String get tipHealthyDetail => rulePhysicalDetail2;
  String get donateNowButton => _en ? 'Donate Now' : 'Donor Sekarang';
  String get educationModalTitle =>
      _en ? 'Donation Education & Benefits' : 'Edukasi & Manfaat Donor';
  String get educationSectionTitle =>
      _en ? 'Blood Donation Education' : 'Edukasi Donor Darah';
  String get eduSafeTitle => _en ? 'Safe Blood Donation' : 'Donor Darah Aman';
  String get eduSafeDesc => _en
      ? 'Process uses sterile single-use equipment supervised by medical staff.'
      : 'Proses menggunakan alat steril sekali pakai dan diawasi tenaga medis.';
  String get eduHealthTitle =>
      _en ? 'Meeting Health Requirements' : 'Memenuhi Syarat Kesehatan';
  String get eduHealthDesc => _en
      ? 'Before donating, general health is checked to ensure the donor is healthy.'
      : 'Sebelum donor, pendonor akan diperiksa kondisi umum untuk memastikan tubuh dalam keadaan sehat.';
  String get eduRoutineTitle =>
      _en ? 'Donate Regularly' : 'Donor Dilakukan Secara Rutin';
  String get eduRoutineDesc => _en
      ? 'Blood donation can be done every 2-3 months to maintain blood supply.'
      : 'Donor darah bisa dilakukan setiap 2-3 bulan sekali untuk menjaga ketersediaan stok darah bagi yang membutuhkan.';
  String get benefitsSectionTitle =>
      _en ? 'Benefits of Blood Donation' : 'Manfaat Donor Darah';
  String get benefitHeartTitle =>
      _en ? 'Maintains Heart Health' : 'Menjaga Kesehatan Jantung';
  String get benefitHeartDesc => _en
      ? 'Donating blood helps keep blood viscosity stable'
      : 'Donor darah membantu menjaga kekentalan darah tetap stabil';
  String get benefitDetectionTitle =>
      _en ? 'Early Detection of Serious Illness' : 'Deteksi Penyakit Serius';
  String get benefitDetectionDesc => _en
      ? 'Health screening before donation helps detect conditions early.'
      : 'Sebelum donor, dilakukan pemeriksaan kesehatan, sehingga dapat mengetahui kondisi kesehatan sejak awal.';
  String get benefitProductionTitle => _en
      ? 'Stimulates New Blood Cell Production'
      : 'Meningkatkan Produksi Sel Darah Baru';
  String get benefitProductionDesc => _en
      ? 'After donating, the body produces new red blood cells to replace those lost'
      : 'Setelah donor, tubuh akan merangsang pembentukan sel darah merah baru untuk menggantikan yang hilang';

  // ---- Jadwal ----
  String get scheduleLocationTitle =>
      _en ? 'Donation Schedule & Location' : 'Jadwal & Lokasi Donor';
  String get selectDatePrompt =>
      _en ? 'Please select a donation date' : 'Silahkan pilih tanggal donor';
  String get selectSchedulePrompt =>
      _en ? 'Please select a donation schedule:' : 'Silahkan pilih jadwal donor :';
  String get noScheduleForDate => _en
      ? 'No donation schedules available for this date'
      : 'Tidak ada jadwal donor tersedia untuk tanggal ini';
  String quotaRemaining(int n) =>
      _en ? '$n slots left' : 'Sisa $n kuota';

  // ---- Kuisioner ----
  String get healthQuestionnaireTitle =>
      _en ? 'Health Questionnaire' : 'Kuesioner Kesehatan';
  String get questionnaireIntro => _en
      ? 'Please answer the questions below before continuing'
      : 'Silahkan untuk menjawab beberapa pertanyaan di bawah sebelum lanjut';
  List<String> get questionnaireQuestions => _en
      ? const [
          'Do you currently have fever, flu, cough, or illness?',
          'Do you feel healthy today?',
          'Have you ever been hospitalized?',
          'Have you eaten in the last 3-4 hours?',
          'Have you consumed alcohol in the last 24 hours?',
          'Are you currently taking certain medications?',
          'Have you ever fainted or felt dizzy during previous donations?',
          'Do you have a history of heart disease, blood pressure issues, or diabetes?',
          'Have you been diagnosed with hepatitis, HIV/AIDS, or blood-borne diseases?',
          'Are you pregnant or breastfeeding? (for women)',
          'Have you had surgery or medical procedures in the last 6 months?',
          'Have you received vaccination in the last month?',
          'Are you willing to donate blood voluntarily without coercion?',
        ]
      : const [
          'Apakah Anda sedang demam, flu, batuk, atau sakit?',
          'Apakah Anda merasa sehat hari ini?',
          'Apakah pernah dirawat di rumah sakit',
          'Apakah Anda sudah makan dalam 3-4 jam terakhir?',
          'Apakah Anda mengonsumsi alkohol dalam 24 jam terakhir?',
          'Apakah Anda sedang mengonsumsi obat-obatan tertentu?',
          'Apakah Anda pernah pingsan atau pusing saat donor darah sebelumnya?',
          'Apakah Anda memiliki riwayat penyakit jantung, tekanan darah, atau diabetes?',
          'Apakah Anda pernah didiagnosis hepatitis, HIV/AIDS, atau penyakit menular darah?',
          'Apakah Anda sedang hamil atau menyusui? (untuk wanita)',
          'Apakah Anda baru menjalani operasi, atau tindakan medis dalam 6 bulan terakhir?',
          'Apakah Anda baru menerima vaksinasi dalam 1 bulan terakhir?',
          'Apakah Anda bersedia mendonorkan darah secara sukarela tanpa paksaan?',
        ];

  // ---- Konfirmasi donor ----
  String get donorTitle => _en ? 'Donate' : 'Donor';
  String get donationConfirmTitle =>
      _en ? 'Donation Confirmation' : 'Konfirmasi Donor';
  String get donationDateLabel => _en ? 'Donation Date' : 'Tanggal Donor';
  String get donationTimeLabel => _en ? 'Donation Time' : 'Jam Donor';
  String get donationLocationLabel =>
      _en ? 'Donation Location' : 'Lokasi Donor';
  String get healthSectionTitle => _en ? 'Health:' : 'Kesehatan :';
  String get registrationSuccess =>
      _en ? 'Registration successful' : 'Berhasil melakukan pendaftaran';
  String get feedbackTitle => 'FeedBack';
  String get experienceQuestion =>
      _en ? 'How was your experience?' : 'Bagaimana Pengalaman Anda?';
  String get feedbackHintLabel => _en
      ? 'Write your suggestions or complaints'
      : 'Tulis Saran atau Keluhan Anda';
  String get sendFeedbackButton => _en ? 'Send Feedback' : 'Kirim FeedBack';

  // ---- Riwayat ----
  String get filterLastMonth => _en ? 'Last 1 Month' : '1 Bulan Terakhir';
  String get filterLast6Months => _en ? 'Last 6 Months' : '6 Bulan Terakhir';
  String get filterLastYear => _en ? 'Last 1 Year' : '1 Tahun Terakhir';
  String get historyTitle => _en ? 'Donation History' : 'Riwayat Donor';
  String get historyTab => _en ? 'Donation History' : 'Riwayat Donor';
  String get registrationTab => _en ? 'Registrations' : 'Pendaftaran';
  String get noHistoryInPeriod => _en
      ? 'No donation history for this period'
      : 'Belum ada riwayat donor pada periode ini';
  String get noRegistrations =>
      _en ? 'No donation registrations yet' : 'Belum ada pendaftaran donor';
  String queueNumber(int n) => _en ? 'Queue #$n' : 'Antrian #$n';
  String get cancelRegistrationButton =>
      _en ? 'Cancel Registration' : 'Batalkan Pendaftaran';
  String get cancelRegistrationTitle =>
      _en ? 'Cancel Registration?' : 'Batalkan Pendaftaran?';
  String cancelRegistrationMessage(String lokasi, String tanggal) => _en
      ? 'Are you sure you want to cancel the donation registration at $lokasi on $tanggal?'
      : 'Yakin ingin membatalkan pendaftaran donor di $lokasi pada $tanggal?';
  String get yesCancelButton => _en ? 'Yes, Cancel' : 'Ya, Batalkan';
  String get cancelFailed =>
      _en ? 'Failed to cancel, please try again.' : 'Gagal membatalkan, coba lagi.';
  String get screeningNegative => _en ? 'Negative' : 'Negatif';
  String get screeningPositive => _en ? 'Positive' : 'Positif';
  String get healthStatusTitle => _en ? 'Health Status' : 'Status Kesehatan';
  String get hemoglobinLabel => 'Hemoglobin';
  String get normalLabel => 'Normal';

  // ---- Profil ----
  String get profileTitle => _en ? 'Profile' : 'Profil';
  String get loadProfileFailed =>
      _en ? 'Failed to load profile, please try again.' : 'Gagal memuat profil, coba lagi.';
  String get personalInfoSection =>
      _en ? 'Personal Information' : 'Informasi Pribadi';
  String get editProfileButton => _en ? 'Edit Profile' : 'Edit Profil';
  String get editPasswordButton => _en ? 'Edit Password' : 'Edit Password';
  String get otherSection => _en ? 'Other' : 'Lainnya';
  String get donorCertification =>
      _en ? 'Donor Certification' : 'Sertifikasi Pendonor';
  String get openGalleryButton => _en ? 'Open Gallery' : 'Buka Galeri';
  String get editProfileTitle => _en ? 'Edit Profile' : 'Edit Profil';
  String get fullNameRequired =>
      _en ? 'Full name cannot be empty' : 'Nama lengkap tidak boleh kosong';
  String get profileUpdated =>
      _en ? 'Profile updated successfully' : 'Profil berhasil diperbarui';
  String get saveFailed =>
      _en ? 'Failed to save, please try again.' : 'Gagal menyimpan, coba lagi.';
  String get bloodTypeExampleHint => _en ? 'Example: O+' : 'Contoh: O+';
  String get editPasswordTitle => _en ? 'Edit Password' : 'Edit Password';
  String get changePasswordTitle => _en ? 'Change Password' : 'Ubah Password';
  String get currentPasswordLabel =>
      _en ? 'Current Password' : 'Password Saat Ini';
  String get currentPasswordHint =>
      _en ? 'Enter current password' : 'Masukkan password sekarang';
  String get newPasswordLabel => _en ? 'New Password' : 'Password Baru';
  String get newPasswordHint =>
      _en ? 'Enter new password' : 'Masukkan password baru';
  String get confirmNewPasswordLabel =>
      _en ? 'Confirm New Password' : 'Konfirmasi Password Baru';
  String get confirmNewPasswordHint =>
      _en ? 'Re-enter new password' : 'Masukkan kembali password baru';
  String get passwordChanged =>
      _en ? 'Password changed successfully' : 'Password berhasil diubah';
  String get changePasswordFailed => _en
      ? 'Failed to change password, please try again.'
      : 'Gagal mengubah password, coba lagi.';

  // ---- Sertifikat ----
  String get certificateGalleryTitle =>
      _en ? 'Certificate Gallery' : 'Galeri Sertifikat';
  String get certificateHistoryTitle =>
      _en ? 'Certificate History' : 'Riwayat Sertifikat';
  String get loadCertificateFailed => _en
      ? 'Failed to load certificates, please try again.'
      : 'Gagal memuat sertifikat, coba lagi.';
  String get noCertificates =>
      _en ? 'No donor certificates yet' : 'Belum ada sertifikat donor';
  String get pdfCreateFailed =>
      _en ? 'Failed to create PDF' : 'Gagal membuat PDF';
  String get pdfShareFailed =>
      _en ? 'Failed to share PDF' : 'Gagal membagikan PDF';
  String sharePdfSubject(String name) =>
      _en ? 'Blood Donation Certificate - $name' : 'Sertifikat Donor Darah - $name';
  String get certAppreciationHeader =>
      _en ? 'CERTIFICATE OF APPRECIATION' : 'SERTIFIKAT APRESIASI';
  String get certBloodDonorHeader =>
      _en ? 'BLOOD DONOR' : 'DONOR DARAH';
  String get certPresentedTo =>
      _en ? 'Proudly presented to:' : 'Diberikan dengan bangga kepada:';
  String get dateLabel => _en ? 'Date' : 'Tanggal';
  String get locationLabel => _en ? 'Location' : 'Lokasi';
  String get volumeLabel => 'Volume';
  String get certThankYouMessage => _en
      ? 'Thank you for your invaluable voluntary contribution in saving lives.'
      : 'Terima kasih atas kontribusi sukarela Anda yang\ntak ternilai dalam menyelamatkan nyawa sesama.';
  String get signatoryRoleUdd => _en ? 'Head of UDD PMI' : 'Kepala UDD PMI';
  String get signatoryRoleChair => _en ? 'Chairman of PMI' : 'Ketua PMI';
  String certificateNumber(String number) =>
      _en ? 'Certificate No.: $number' : 'No. Sertifikat : $number';
  String voluntaryDonorTitle(String location) => _en
      ? 'Voluntary Blood Donation - $location'
      : 'Donor Darah Sukarela - $location';
  String get downloadPdfButton => _en ? 'Download PDF' : 'Unduh PDF';
  String get shareButton => _en ? 'Share' : 'Bagikan';

  // ---- Status domain ----
  String get statusBerhasil => _en ? 'Successful' : 'Berhasil';
  String get statusGagal => _en ? 'Failed' : 'Gagal';
  String get statusDitunda => _en ? 'Postponed' : 'Ditunda';
  String get statusMenunggu => _en ? 'Pending' : 'Menunggu';
  String get statusDiterima => _en ? 'Accepted' : 'Diterima';
  String get statusDitolak => _en ? 'Rejected' : 'Ditolak';
  String get statusDibatalkan => _en ? 'Cancelled' : 'Dibatalkan';
  String get statusSelesai => _en ? 'Completed' : 'Selesai';
  String get statusTidakHadir => _en ? 'No Show' : 'Tidak Hadir';
  String get statusBelumAdaJadwal =>
      _en ? 'No Schedule Yet' : 'Belum Ada Jadwal';

  String labelStatusDonor(String kode) => switch (kode) {
        'berhasil' => statusBerhasil,
        'gagal' => statusGagal,
        'ditunda' => statusDitunda,
        _ => kode,
      };

  String labelStatusPendaftaran(String kode) => switch (kode) {
        'menunggu' => statusMenunggu,
        'diterima' => statusDiterima,
        'ditolak' => statusDitolak,
        'dibatalkan' => statusDibatalkan,
        'selesai' => statusSelesai,
        'batal_hadir' => statusTidakHadir,
        _ => kode,
      };

  String labelStatusRiwayat(String kode) => switch (kode) {
        'berhasil' => statusSelesai,
        'gagal' => statusGagal,
        'ditunda' => statusDitunda,
        _ => kode,
      };

  // ---- Bantuan ----
  String get contactSupportTitle =>
      _en ? 'Contact Support Staff' : 'Hubungi Staf Dukungan';
  String get csGreetingName => _en ? "Hello! I'm Revan" : 'Halo! Saya Revan';
  String get csGreetingTeam =>
      _en ? 'from the Support Team' : 'dari Tim Dukungan';
  String get csTopicPrompt => _en
      ? 'Choose a topic below so I can help you faster'
      : 'Pilih topik dibawah ini agar saya bisa membantumu lebih cepat';
  String get topicDonorIssue => _en ? 'Donation Issues' : 'Masalah Donor';
  String get topicAccountIssue => _en ? 'Account Issues' : 'Masalah Akun';
  String get topicLocationInfo =>
      _en ? 'Location Information' : 'Informasi Lokasi';
  String get topicOther => _en ? 'Other' : 'Lainnya';
  String get csMessageHint =>
      _en ? 'Type a message for admin here...' : 'Ketik pesan untuk admin disini...';
  String get rezaChatbotTitle => 'Reza Chatbot';
  String get rezaGreeting => _en ? 'Hello, User' : 'Halo, User';
  String get rezaIntroLine1 => _en ? 'Reza is here to' : 'Reza di sini akan';
  String get rezaIntroLine2 => _en ? 'help you' : 'membantumu';
  String get rezaSuggestionSyarat =>
      _en ? 'What are the requirements?' : 'Apa syarat donor darah?';
  String get rezaSuggestionJarak =>
      _en ? 'Donation interval' : 'Berapa jarak antar donor?';
  String get rezaSuggestionCaraDaftar =>
      _en ? 'How to register?' : 'Bagaimana cara daftar?';
  String get rezaSuggestionLokasi =>
      _en ? 'Nearest location' : 'Lokasi donor terdekat?';
  String get rezaInputHint =>
      _en ? 'Ask Reza Chatbot..' : 'Tanya Reza Chatbot..';

  // ---- Bulan ----
  List<String> get namaBulan => _en
      ? const [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December',
        ]
      : const [
          'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
          'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
        ];

  String formatTanggal(DateTime t) =>
      '${t.day} ${namaBulan[t.month - 1]} ${t.year}';
}

class AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppBahasa.values.any((b) => b.kode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) {
    final bahasa = AppBahasa.dariKode(locale.languageCode);
    return SynchronousFuture<AppStrings>(AppStrings.dariBahasa(bahasa));
  }

  @override
  bool shouldReload(AppStringsDelegate old) => false;
}
