import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supply_mate/main.dart';
import 'package:supply_mate/screens/auth/login_screen.dart';
import 'package:supply_mate/widgets/peer_card.dart';

void main() {
  testWidgets('App launches', (WidgetTester tester) async {
    await tester.pumpWidget(const SupplyMateApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Login screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    expect(find.text('Login'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
  });

  testWidgets('Peer card renders', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PeerCard(
          user: User(
            id: '1',
            name: 'Test User',
            subjects: ['Math', 'Science'],
            location: const LatLng(0, 0),
            profileImageUrl: '',
            isOnline: true,
            lastSeen: DateTime.now(),
          ),
          onTap: () {},
        ),
      ),
    ));
    expect(find.text('Test User'), findsOneWidget);
    expect(find.text('Math, Science'), findsOneWidget);
  });
}