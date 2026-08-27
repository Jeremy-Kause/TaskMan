import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Renders main navigation pages', (WidgetTester tester) async {

    expect(find.text('Halaman Home'), findsOneWidget);
    expect(find.byIcon(Icons.home_rounded), findsWidgets);

    await tester.tap(find.text('Calendar'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Calendar'), findsOneWidget);
    expect(find.textContaining('Tanggal hari ini:'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Halaman Profile'), findsOneWidget);
  });
}
