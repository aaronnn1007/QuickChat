import 'package:flutter/material.dart';

class MessageInput extends StatefulWidget {
  final void Function(String text) onSend;
  const MessageInput({super.key, required this.onSend});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message',
                  border: OutlineInputBorder(),
                  isDense: true,
                ),
                onSubmitted: (_) => _submit(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton(
              onPressed: _submit,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
