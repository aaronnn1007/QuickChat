import 'package:flutter/foundation.dart';

class ChatPreview {
  final String name;
  final String lastMessage;
  final String timeLabel;
  final int unread;

  const ChatPreview({
    required this.name,
    required this.lastMessage,
    required this.timeLabel,
    required this.unread,
  });

  ChatPreview copyWith({
    String? name,
    String? lastMessage,
    String? timeLabel,
    int? unread,
  }) => ChatPreview(
        name: name ?? this.name,
        lastMessage: lastMessage ?? this.lastMessage,
        timeLabel: timeLabel ?? this.timeLabel,
        unread: unread ?? this.unread,
      );
}

class ChatRepository {
  ChatRepository._();
  static final ChatRepository instance = ChatRepository._();

  final ValueNotifier<List<ChatPreview>> chats = ValueNotifier<List<ChatPreview>>([
    const ChatPreview(
        name: 'Alice Johnson',
        lastMessage: 'Are we still on for tonight?',
        timeLabel: '9:41 AM',
        unread: 2),
    const ChatPreview(
        name: 'Bob Smith', lastMessage: 'Got it, thanks!', timeLabel: 'Yesterday', unread: 0),
    const ChatPreview(
        name: 'Carol Danvers',
        lastMessage: 'Sending over the files now.',
        timeLabel: 'Mon',
        unread: 1),
    const ChatPreview(name: 'Dev Team', lastMessage: 'CI passed ✅', timeLabel: 'Sun', unread: 0),
    const ChatPreview(
        name: 'Ethan Lee', lastMessage: "Let's catch up soon.", timeLabel: 'Sat', unread: 3),
    const ChatPreview(name: 'Family Group', lastMessage: 'Dinner at 7?', timeLabel: 'Fri', unread: 0),
  ]);

  final Map<String, List<String>> _messages = <String, List<String>>{};

  List<String> getMessages(String name) {
    return List<String>.unmodifiable(_messages.putIfAbsent(name, () => <String>[]));
  }

  void sendMessage({required String name, required String text, DateTime? time}) {
    final now = time ?? DateTime.now();
    String label = _formatTimeLabel(now);
    // store message
    final msgs = _messages.putIfAbsent(name, () => <String>[]);
    msgs.add(text);
    final list = List<ChatPreview>.from(chats.value);
    final idx = list.indexWhere((e) => e.name == name);
    ChatPreview updated = ChatPreview(name: name, lastMessage: text, timeLabel: label, unread: 0);
    if (idx >= 0) {
      list.removeAt(idx);
    }
    list.insert(0, updated);
    chats.value = list;
  }

  void addContact({required String name}) {
    final list = List<ChatPreview>.from(chats.value);
    final exists = list.any((e) => e.name.toLowerCase() == name.toLowerCase());
    if (exists) return;
    list.insert(
      0,
      ChatPreview(
        name: name.trim(),
        lastMessage: '',
        timeLabel: '',
        unread: 0,
      ),
    );
    chats.value = list;
  }

  String _formatTimeLabel(DateTime dt) {
    // Minimal formatting: show HH:MM for today, otherwise use weekday abbrev.
    final now = DateTime.now();
    final isSameDay = dt.year == now.year && dt.month == now.month && dt.day == now.day;
    if (isSameDay) {
      String two(int n) => n.toString().padLeft(2, '0');
      return '${two(dt.hour)}:${two(dt.minute)}';
    }
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[dt.weekday - 1];
  }
}
