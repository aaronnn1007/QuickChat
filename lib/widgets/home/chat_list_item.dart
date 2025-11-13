import 'package:flutter/material.dart';

class ChatListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unread;
  final VoidCallback onTap;

  const ChatListItem({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(_initials(name)),
      ),
      title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: Theme.of(context).textTheme.labelSmall,
          ),
          if (unread > 0)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                unread.toString(),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: Colors.white),
              ),
            ),
        ],
      ),
      onTap: onTap,
    );
  }

  String _initials(String s) {
    final parts = s.trim().split(RegExp(r"\s+"));
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts[0].isNotEmpty ? parts[0][0] : '') +
        (parts[1].isNotEmpty ? parts[1][0] : '');
  }
}
