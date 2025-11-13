import 'package:flutter/material.dart';
import 'chat_list_item.dart';
import '../../data/chat_repository.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<ChatPreview>>(
      valueListenable: ChatRepository.instance.chats,
      builder: (context, chats, _) {
        return ListView.separated(
          itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final c = chats[index];
            return ChatListItem(
              name: c.name,
              lastMessage: c.lastMessage,
              time: c.timeLabel,
              unread: c.unread,
              onTap: () => Navigator.pushNamed(
                context,
                '/chat',
                arguments: {'name': c.name},
              ),
            );
          },
        );
      },
    );
  }
}
