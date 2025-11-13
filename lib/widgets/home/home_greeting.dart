import 'package:flutter/material.dart';

class HomeGreeting extends StatelessWidget {
  const HomeGreeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back 👋',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          'Start a new chat with a friend',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => Navigator.pushNamed(context, '/add-contact'),
          icon: const Icon(Icons.person_add_alt),
          label: const Text('Add contact'),
        ),
      ],
    );
  }
}
