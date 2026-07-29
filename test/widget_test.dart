import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:donorku_app/main.dart';

void main() {
  testWidgets('DonorkuApp builds without error', (WidgetTester tester) async {
    // Pastikan aplikasi bisa dibangun (build) tanpa error.
    await tester.pumpWidget(const DonorkuApp());

    // Cek bahwa MaterialApp berhasil ter-render.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}