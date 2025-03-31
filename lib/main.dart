import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:supply_mate/services/auth_service.dart';
import 'package:supply_mate/models/user_model.dart';
import 'package:supply_mate/themes/app_theme.dart';
import 'package:supply_mate/screens/auth/login_screen.dart';
import 'package:supply_mate/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _auth.user,
      builder: (context, snapshot) {
        return MaterialApp(
          title: 'SupplyMate',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: _getHomePage(snapshot),
        );
      },
    );
  }

  Widget _getHomePage(AsyncSnapshot<User?> snapshot) {
    if (snapshot.connectionState == ConnectionState.active) {
      return snapshot.hasData ? HomeScreen() : LoginScreen();
    }
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          color: Color(0xFFFF5722), // Using your primary color
        ),
      ),
    );
  }
}
