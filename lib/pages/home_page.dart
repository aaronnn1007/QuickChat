import 'package:flutter/material.dart';
import '../widgets/home/chat_list.dart';
import '../data/chat_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QuickChat')),
      body: const ChatList(),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/add-contact');
          if (result is Map) {
            final name = result['name'];
            if (name is String && name.trim().isNotEmpty) {
              ChatRepository.instance.addContact(name: name.trim());
            }
          }
        },
        tooltip: 'Add Contact',
        child: const Icon(Icons.add),
      ),
    );
  }
}
