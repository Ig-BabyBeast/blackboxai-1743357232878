import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get chat room ID
  String _getChatRoomId(String userId1, String userId2) {
    return userId1.compareTo(userId2) < 0
        ? '${userId1}_$userId2'
        : '${userId2}_$userId1';
  }

  // Send message
  Future<void> sendMessage(String receiverId, String message) async {
    final currentUser = _auth.currentUser!;
    final chatRoomId = _getChatRoomId(currentUser.uid, receiverId);
    final timestamp = Timestamp.now();
    final messageData = {
      'senderId': currentUser.uid,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'read': false,
      'reactions': {},
    };

    try {
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      // Cache message if offline
      await LocalStorageService.cacheMessage(chatRoomId, {
        ...messageData,
        'timestamp': timestamp.toDate().toIso8601String(),
      });
      rethrow;
    }
  }

  // Get messages stream
  Stream<QuerySnapshot> getMessages(String userId, String peerId) {
    final chatRoomId = _getChatRoomId(userId, peerId);
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String chatRoomId, String userId) async {
    final unreadMessages = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (final doc in unreadMessages.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
  }

  // Typing indicators
  Future<void> setTypingStatus(String chatRoomId, String userId, bool isTyping) async {
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .update({
          'typing.$userId': isTyping,
          'lastTypingUpdate': FieldValue.serverTimestamp(),
        });
  }

  Stream<DocumentSnapshot> getTypingStatus(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .snapshots();
  }
}
