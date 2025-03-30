import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class PresenceService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _presenceRef = FirebaseDatabase.instance.ref('presence');
  final Connectivity _connectivity = Connectivity();

  Future<void> init() async {
    _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    await _updatePresence(true);
  }

  Future<void> _updatePresence(bool isOnline) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return;

    await _presenceRef.child(userId).set({
      'isOnline': isOnline,
      'lastSeen': ServerValue.timestamp,
    });
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    await _updatePresence(result != ConnectivityResult.none);
  }

  Stream<Map<String, dynamic>> getUserPresence(String userId) {
    return _presenceRef.child(userId).onValue.map((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>? ?? {};
      return {
        'isOnline': data['isOnline'] ?? false,
        'lastSeen': data['lastSeen'],
      };
    });
  }
}