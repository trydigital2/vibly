import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vibly/main.dart';

void main() {
  testWidgets('Vibly app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: ViblyApp(),
      ),
    );

    // Initial frame
    await tester.pump();

    // Verify Vibly splash screen elements render
    expect(find.text('Vibly'), findsOneWidget);
    expect(find.text('Meet people. Find your vibe.'), findsOneWidget);

    // Dispose by replacing with empty container
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 4));
  });
}
