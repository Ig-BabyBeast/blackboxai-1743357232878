import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:supply_mate/screens/splash_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await LocalStorageService.init();
  await PresenceService().init();
  runApp(const SupplyMateApp());
}

class SupplyMateApp extends StatelessWidget {
  const SupplyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supply Mate',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF3B82F6),
          primary: const Color(0xFF3B82F6),
          secondary: const Color(0xFFEF4444),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}