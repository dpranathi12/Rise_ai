import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rise_ai/main.dart';

void main() {
  testWidgets('RiseAI app smoke test - app launches', (WidgetTester tester) async {
    // Build the RiseAIApp and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: RiseAIApp(),
      ),
    );

    // Verify the splash screen renders with RiseAI branding.
    expect(find.text('RiseAI'), findsOneWidget);
    expect(find.text('Smart Alarm & Wake-Up Coach'), findsOneWidget);
  });
}
