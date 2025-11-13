import 'package:flutter/material.dart';
import '../widgets/chat/message_list.dart';
import '../widgets/chat/message_input.dart';
import '../data/chat_repository.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String? _name;
  List<String> _messages = [];

  void _handleSend(String text) {
    final name = _name;
    if (name != null && name.isNotEmpty) {
      ChatRepository.instance.sendMessage(name: name, text: text);
      setState(() {
        _messages = ChatRepository.instance.getMessages(name);
      });
    } else {
      // Fallback if no name provided
      setState(() => _messages = List<String>.from(_messages)..add(text));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_name == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['name'] is String) {
        _name = args['name'] as String;
      }
      if (_name != null) {
        _messages = ChatRepository.instance.getMessages(_name!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_name ?? 'Chat')),
      body: Column(
        children: [
          Expanded(child: MessageList(messages: _messages)),
          MessageInput(onSend: _handleSend),
        ],
      ),
    );
  }
}
