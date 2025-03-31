import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supply_mate/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Convert Firebase User to our User model
  User? _userFromFirebase(User? user) {
    if (user == null) return null;
    
    return User(
      id: user.uid,
      name: user.displayName ?? 'New User',
      email: user.email ?? '',
      subjects: [],
      location: const LatLng(0, 0), // Default location
      profileImageUrl: user.photoURL ?? '',
      isOnline: true,
      lastSeen: DateTime.now(),
    );
  }

  // User stream that returns our User model
  Stream<User?> get user {
    return _auth.authStateChanges().asyncMap(_userFromFirebase);
  }

  // Email/Password Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update user status
      await _updateUserStatus(userCredential.user!.uid, true);
      
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Google Sign-In
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      
      // Create user document if new user
      if (userCredential.additionalUserInfo!.isNewUser) {
        await _createUserDocument(userCredential.user!);
      } else {
        await _updateUserStatus(userCredential.user!.uid, true);
      }
      
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Email/Password Sign Up
  Future<User?> signUpWithEmail(
    String name,
    String email, 
    String password,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name
      await userCredential.user?.updateDisplayName(name);
      
      // Create user document
      await _createUserDocument(userCredential.user!);
      
      return _userFromFirebase(userCredential.user);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Sign Out
  Future<void> signOut() async {
    try {
      // Update user status before signing out
      if (_auth.currentUser != null) {
        await _updateUserStatus(_auth.currentUser!.uid, false);
      }
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('Sign out error: $e');
      rethrow;
    }
  }

  // Helper: Create user document in Firestore
  Future<void> _createUserDocument(User user) async {
    final newUser = User(
      id: user.uid,
      name: user.displayName ?? 'New User',
      email: user.email ?? '',
      subjects: [],
      location: const LatLng(0, 0),
      profileImageUrl: user.photoURL ?? '',
      isOnline: true,
      lastSeen: DateTime.now(),
    );
    
    await _firestore
      .collection('users')
      .doc(user.uid)
      .set(newUser.toMap());
  }

  // Helper: Update user online status
  Future<void> _updateUserStatus(String userId, bool isOnline) async {
    await _firestore.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': DateTime.now().toIso8601String(),
    });
  }

  // Error Handling
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Please enter a valid email address';
      case 'user-disabled':
        return 'This account has been disabled';
      case 'user-not-found':
        return 'No account found for this email';
      case 'wrong-password':
        return 'Incorrect password';
      case 'email-already-in-use':
        return 'This email is already registered';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled';
      case 'weak-password':
        return 'Password should be at least 6 characters';
      default:
        return 'An error occurred. Please try again';
    }
  }
}