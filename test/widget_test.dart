import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lifelink/main.dart'; // ✅ make sure this matches your project name

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const LifeLinkApp());
    // Example: look for "Donor Dashboard" text or whatever's on screen
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
