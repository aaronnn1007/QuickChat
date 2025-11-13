import 'package:flutter/material.dart';
import 'message_tile.dart';

class MessageList extends StatelessWidget {
  final List<String> messages;
  const MessageList({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    if (messages.isEmpty) {
      return const Center(
        child: Text('No messages yet. Say hi!'),
      );
    }
    return ListView.builder(
      reverse: true,
      padding: const EdgeInsets.all(12),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final msg = messages[messages.length - 1 - index];
        return MessageTile(text: msg, isMe: index % 2 == 0);
      },
    );
  }
}
