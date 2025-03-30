import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supply_mate/models/user_model.dart';
import 'package:supply_mate/services/chat_service.dart';
import 'package:supply_mate/widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final User peer;
  const ChatScreen({super.key, required this.peer});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isMe': true,
        'timestamp': DateTime.now(),
      });
    });

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.peer.profileImageUrl),
              radius: 18,
            ),
            const SizedBox(width: 10),
            Text(widget.peer.name),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
          child: Column(
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: _chatService.getTypingStatus(
                  _chatService._getChatRoomId(currentUserId, widget.peer.id),
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData && 
                      snapshot.data!.exists &&
                      (snapshot.data!['typing']?[widget.peer.id] ?? false)) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${widget.peer.name} is typing...',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
            stream: _chatService.getMessages(currentUserId, widget.peer.id),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.builder(
                reverse: true,
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final message = snapshot.data!.docs[index];
                  return MessageBubble(
                    text: message['message'],
                    isMe: message['senderId'] == currentUserId,
                    timestamp: message['timestamp'].toDate(),
                    isRead: message['read'] ?? false,
                  );
                },
              );
            },
          ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}