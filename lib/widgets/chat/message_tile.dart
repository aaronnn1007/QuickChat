import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String text;
  final bool isMe;
  const MessageTile({super.key, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.blue : Colors.grey.shade300;
    final fg = isMe ? Colors.white : Colors.black87;
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isMe
        ? const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
          );

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
          decoration: BoxDecoration(color: bg, borderRadius: radius),
          child: Text(text, style: TextStyle(color: fg)),
        ),
      ],
    );
  }
}
