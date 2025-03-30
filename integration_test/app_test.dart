import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:supply_mate/main.dart';
import 'package:supply_mate/screens/auth/login_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Full app navigation test', (WidgetTester tester) async {
    await tester.pumpWidget(const SupplyMateApp());
    
    // Verify login screen appears
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));

    // Test invalid login
    await tester.enterText(find.byType(TextField).first, 'test@email.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify error handling
    expect(find.text('Invalid credentials'), findsNothing);
  });

  testWidgets('Login screen validation', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    
    // Test empty submission
    await tester.tap(find.text('Login'));
    await tester.pump();
    expect(find.text('Please enter email'), findsOneWidget);
    expect(find.text('Please enter password'), findsOneWidget);
  });
}