import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import '../../core/locale/app_strings.dart';
import '../../theme/app_theme.dart';
import '../../model/data_sertifikat.dart';
import '../../services/sertifikat/sertifikat_service.dart';
import '../../services/core/api_exception.dart';

/// Halaman Galeri Sertifikat (P-003).
class GaleriSertifikatPage extends StatefulWidget {
  const GaleriSertifikatPage({super.key});

  @override
  State<GaleriSertifikatPage> createState() => _GaleriSertifikatPageState();
}

class _GaleriSertifikatPageState extends State<GaleriSertifikatPage> {
  final SertifikatService _service = SertifikatService();

  List<DataSertifikat> _daftar = [];
  bool _sedangMemuat = false;
  String? _pesanError;
  int _indeksTerpilih = 0;
  bool _sedangUnduh = false;
  bool _sedangBagi = false;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  Future<void> _muatData() async {
    setState(() { _sedangMemuat = true; _pesanError = null; });
    try {
      final hasil = await _service.ambilDaftarSertifikat();
      setState(() => _daftar = hasil);
    } on ApiException catch (e) {
      setState(() => _pesanError = e.message);
    } catch (_) {
      setState(() => _pesanError = AppStrings.of(context).loadCertificateFailed);
    } finally {
      if (mounted) setState(() => _sedangMemuat = false);
    }
  }

  DataSertifikat? get _sertifikatTerpilih =>
      _daftar.isEmpty ? null : _daftar[_indeksTerpilih];

  Future<void> _unduhPdf() async {
    final data = _sertifikatTerpilih;
    if (data == null) return;
    setState(() => _sedangUnduh = true);
    try {
      final bytes = await _buildPdfBytes(data);
      await Printing.layoutPdf(onLayout: (_) async => bytes);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.of(context).pdfCreateFailed)));
      }
    } finally {
      if (mounted) setState(() => _sedangUnduh = false);
    }
  }

  Future<void> _bagikanPdf() async {
    final data = _sertifikatTerpilih;
    if (data == null) return;
    setState(() => _sedangBagi = true);
    try {
      final bytes = await _buildPdfBytes(data);
      final dir = await getTemporaryDirectory();
      final file = File(
          '${dir.path}/sertifikat_${data.nomorSertifikat.replaceAll('/', '_')}.pdf');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/pdf')],
          subject: AppStrings.of(context).sharePdfSubject(data.namaPendonor),
        ),
      );
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppStrings.of(context).pdfShareFailed)));
      }
    } finally {
      if (mounted) setState(() => _sedangBagi = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Scaffold(
      body: SafeArea(
        child: _sedangMemuat
            ? const Center(child: CircularProgressIndicator())
            : _pesanError != null
                ? Center(
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(_pesanError!, textAlign: TextAlign.center),
                      const SizedBox(height: 8),
                      TextButton(onPressed: _muatData, child: Text(s.tryAgain)),
                    ]))
                : _daftar.isEmpty
                    ? Center(
                        child: Text(s.noCertificates,
                            style: const TextStyle(color: AppColors.textSecondary)))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Header
                            Row(children: [
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: const Icon(Icons.arrow_back,
                                    size: 28, color: AppColors.textPrimary),
                              ),
                              Expanded(
                                child: Text(s.certificateGalleryTitle,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary)),
                              ),
                              const SizedBox(width: 28),
                            ]),
                            const SizedBox(height: 16),

                            // Kartu utama
                            Center(
                              child: _KartuSertifikatUtama(
                                data: _sertifikatTerpilih!,
                                sedangUnduh: _sedangUnduh,
                                sedangBagi: _sedangBagi,
                                onUnduh: _unduhPdf,
                                onBagi: _bagikanPdf,
                                s: s,
                              ),
                            ),
                            const SizedBox(height: 24),

                            Text(s.certificateHistoryTitle,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                            const SizedBox(height: 12),

                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 14,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.1,
                              ),
                              itemCount: _daftar.length,
                              itemBuilder: (context, i) {
                                final urutan = _daftar.length - i;
                                return _ItemGaleri(
                                  label: _daftar[i].labelGaleri(urutan),
                                  terpilih: i == _indeksTerpilih,
                                  onTap: () =>
                                      setState(() => _indeksTerpilih = i),
                                  data: _daftar[i],
                                  s: s,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Preview sertifikat — dipakai di kartu utama & grid
// Identik dengan tampilan PDF (termasuk TTD placeholder)
// ---------------------------------------------------------------------------
class _PreviewSertifikat extends StatelessWidget {
  final DataSertifikat data;
  final AppStrings s;

  const _PreviewSertifikat({required this.data, required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(children: [
            Text(s.certAppreciationHeader,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                    height: 1.2)),
            Text(s.certBloodDonorHeader,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                    height: 1.2)),
            const SizedBox(height: 4),
            Text(s.certPresentedTo,
                style: const TextStyle(
                    fontSize: 7,
                    fontStyle: FontStyle.italic,
                    color: Colors.black54)),
            const SizedBox(height: 3),
            Text(data.namaPendonor,
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
          ]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _infoKolom(s.dateLabel, data.tanggalFormat),
              _infoKolom(s.locationLabel, data.lokasiDonor),
              _infoKolom(s.volumeLabel, '${data.darahTerkumpul} ml'),
              _infoKolom(s.bloodTypeShortDot, data.golonganDarah),
            ],
          ),

          Text(
            s.certThankYouMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 6,
                fontStyle: FontStyle.italic,
                color: Colors.black54),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _ttdKolom('dr. Siti Aminah, MARS', s.signatoryRoleUdd),
              _ttdKolom('H. Iwan Setiawan', s.signatoryRoleChair),
            ],
          ),

          Text(s.certificateNumber(data.nomorSertifikat),
              style: const TextStyle(
                  fontSize: 6,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _infoKolom(String label, String nilai) {
    return Column(children: [
      Text(label,
          style: const TextStyle(fontSize: 6, color: Colors.black54)),
      Text(nilai,
          style: const TextStyle(fontSize: 7, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis),
    ]);
  }

  Widget _ttdKolom(String nama, String jabatan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // TTD random (kurva sederhana pakai CustomPaint)
        SizedBox(
          width: 60,
          height: 20,
          child: CustomPaint(painter: _TtdPainter(nama.hashCode)),
        ),
        Container(height: 0.5, width: 60, color: Colors.black54),
        const SizedBox(height: 2),
        Text(nama,
            style: const TextStyle(
                fontSize: 6, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center),
        Text(jabatan,
            style: const TextStyle(fontSize: 5, color: Colors.black54),
            textAlign: TextAlign.center),
      ],
    );
  }
}

/// CustomPainter untuk TTD random berdasarkan seed (hashCode nama)
class _TtdPainter extends CustomPainter {
  final int seed;
  const _TtdPainter(this.seed);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Generate kurva pseudo-random berdasarkan seed
    final r = seed.abs() % 1000;
    final path = Path();
    path.moveTo(4, size.height * 0.7);
    path.cubicTo(
      size.width * (0.2 + (r % 10) * 0.02),
      size.height * (0.2 + (r % 7) * 0.05),
      size.width * (0.5 + (r % 8) * 0.02),
      size.height * (0.8 - (r % 6) * 0.05),
      size.width * 0.7,
      size.height * 0.5,
    );
    path.cubicTo(
      size.width * (0.75 + (r % 5) * 0.02),
      size.height * (0.3 + (r % 9) * 0.04),
      size.width * 0.85,
      size.height * 0.6,
      size.width - 4,
      size.height * 0.4,
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TtdPainter old) => old.seed != seed;
}

// ---------------------------------------------------------------------------
// Kartu sertifikat utama
// ---------------------------------------------------------------------------
class _KartuSertifikatUtama extends StatelessWidget {
  final DataSertifikat data;
  final bool sedangUnduh;
  final bool sedangBagi;
  final VoidCallback onUnduh;
  final VoidCallback onBagi;
  final AppStrings s;

  const _KartuSertifikatUtama({
    required this.data,
    required this.sedangUnduh,
    required this.sedangBagi,
    required this.onUnduh,
    required this.onBagi,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 338,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 4,
              offset: Offset.zero),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Preview sertifikat
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: 280,
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color(0xFF8B0000), width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _PreviewSertifikat(data: data, s: s),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Center(
              child: Text(
                s.voluntaryDonorTitle(data.lokasiDonor),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary),
              ),
            ),
            const SizedBox(height: 4),

            Center(
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Text(data.tanggalFormat,
                    style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                const Text('●', style: TextStyle(fontSize: 10)),
                const SizedBox(width: 8),
                Text('${data.darahTerkumpul}ml',
                    style: const TextStyle(fontSize: 12)),
              ]),
            ),
            const SizedBox(height: 10),
            const Divider(height: 1, color: AppColors.textPrimary),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TombolAksi(
                  label: s.downloadPdfButton,
                  icon: Icons.download_outlined,
                  warnaBackground: AppColors.primary,
                  warnaTeks: Colors.white,
                  warnaIcon: Colors.white,
                  sedangProses: sedangUnduh,
                  onTap: onUnduh,
                ),
                _TombolAksi(
                  label: s.shareButton,
                  icon: Icons.share_outlined,
                  warnaBackground: AppColors.surface,
                  warnaTeks: AppColors.primary,
                  warnaIcon: AppColors.primary,
                  sedangProses: sedangBagi,
                  onTap: onBagi,
                  border: Border.all(color: AppColors.border),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Item grid galeri
// ---------------------------------------------------------------------------
class _ItemGaleri extends StatelessWidget {
  final String label;
  final bool terpilih;
  final VoidCallback onTap;
  final DataSertifikat data;
  final AppStrings s;

  const _ItemGaleri({
    required this.label,
    required this.terpilih,
    required this.onTap,
    required this.data,
    required this.s,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 111,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: terpilih ? AppColors.primary : const Color(0xFF8B0000),
                width: terpilih ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 4,
                    offset: Offset.zero),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(9),
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: 300,
                  height: 170,
                  child: _PreviewSertifikat(data: data, s: s),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                  color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tombol aksi
// ---------------------------------------------------------------------------
class _TombolAksi extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color warnaBackground;
  final Color warnaTeks;
  final Color warnaIcon;
  final bool sedangProses;
  final VoidCallback onTap;
  final Border? border;

  const _TombolAksi({
    required this.label,
    required this.icon,
    required this.warnaBackground,
    required this.warnaTeks,
    required this.warnaIcon,
    required this.sedangProses,
    required this.onTap,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: sedangProses ? null : onTap,
      child: Container(
        width: 140,
        height: 36,
        decoration: BoxDecoration(
          color: warnaBackground,
          borderRadius: BorderRadius.circular(10),
          border: border,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: Offset.zero),
          ],
        ),
        child: sedangProses
            ? Center(
                child: SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: warnaTeks),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 18, color: warnaIcon),
                  const SizedBox(width: 6),
                  Text(label,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                          color: warnaTeks)),
                ],
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// PDF generator
// ---------------------------------------------------------------------------
Future<Uint8List> _buildPdfBytes(DataSertifikat data) async {
  final s = AppStrings.current;
  final pdf = pw.Document();
  final fontRegular = await PdfGoogleFonts.poppinsRegular();
  final fontBold = await PdfGoogleFonts.poppinsBold();
  final fontItalic = await PdfGoogleFonts.poppinsItalic();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(32),
      build: (context) => pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(
              color: PdfColor.fromHex('#8B0000'), width: 3),
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
        ),
        padding: const pw.EdgeInsets.all(32),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(children: [
              pw.Text(s.certAppreciationHeader,
                  style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 22,
                      color: PdfColor.fromHex('#8B0000'))),
              pw.Text(s.certBloodDonorHeader,
                  style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 22,
                      color: PdfColor.fromHex('#8B0000'))),
              pw.SizedBox(height: 12),
              pw.Text(s.certPresentedTo,
                  style: pw.TextStyle(font: fontItalic, fontSize: 11)),
              pw.SizedBox(height: 8),
              pw.Text(data.namaPendonor,
                  style: pw.TextStyle(font: fontBold, fontSize: 24)),
            ]),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                _pdfInfoItem(fontBold, fontRegular, s.dateLabel, data.tanggalFormat),
                pw.SizedBox(width: 24),
                _pdfInfoItem(fontBold, fontRegular, s.locationLabel, data.lokasiDonor),
                pw.SizedBox(width: 24),
                _pdfInfoItem(fontBold, fontRegular, s.volumeLabel, '${data.darahTerkumpul} ml'),
                pw.SizedBox(width: 24),
                _pdfInfoItem(fontBold, fontRegular, s.bloodTypeShortDot, data.golonganDarah),
              ],
            ),
            pw.Text(
              s.certThankYouMessage,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: fontItalic, fontSize: 10),
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceEvenly,
              children: [
                _pdfTtd(fontBold, fontRegular, 'dr. Siti Aminah, MARS', s.signatoryRoleUdd),
                _pdfTtd(fontBold, fontRegular, 'H. Iwan Setiawan', s.signatoryRoleChair),
              ],
            ),
            pw.Text(s.certificateNumber(data.nomorSertifikat),
                style: pw.TextStyle(font: fontBold, fontSize: 9)),
          ],
        ),
      ),
    ),
  );
  return pdf.save();
}

pw.Widget _pdfInfoItem(pw.Font bold, pw.Font regular, String label, String nilai) {
  return pw.Column(children: [
    pw.Text(label, style: pw.TextStyle(font: regular, fontSize: 9)),
    pw.Text(nilai, style: pw.TextStyle(font: bold, fontSize: 10)),
  ]);
}

pw.Widget _pdfTtd(pw.Font bold, pw.Font regular, String nama, String jabatan) {
  // Seed berdasarkan nama supaya TTD konsisten per orang
  final seed = nama.hashCode.abs() % 1000;

  return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
    // TTD sebagai custom painter di PDF
    pw.SizedBox(
      width: 120,
      height: 36,
      child: pw.CustomPaint(
        painter: (canvas, size) {
          canvas.setStrokeColor(PdfColors.black);
          canvas.setLineWidth(1.0);
          canvas.moveTo(4, size.y * 0.3);
          canvas.curveTo(
            size.x * (0.2 + (seed % 10) * 0.02),
            size.y * (0.8 - (seed % 7) * 0.05),
            size.x * (0.5 + (seed % 8) * 0.02),
            size.y * (0.2 + (seed % 6) * 0.05),
            size.x * 0.7,
            size.y * 0.5,
          );
          canvas.curveTo(
            size.x * (0.75 + (seed % 5) * 0.02),
            size.y * (0.7 - (seed % 9) * 0.04),
            size.x * 0.85,
            size.y * 0.4,
            size.x - 4,
            size.y * 0.6,
          );
          canvas.strokePath();
        },
      ),
    ),
    pw.Container(height: 1, width: 120, color: PdfColors.black),
    pw.SizedBox(height: 4),
    pw.Text(nama, style: pw.TextStyle(font: bold, fontSize: 9)),
    pw.Text(jabatan, style: pw.TextStyle(font: regular, fontSize: 9)),
  ]);
}