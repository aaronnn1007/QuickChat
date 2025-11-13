import 'package:flutter/material.dart';

class SettingsList extends StatefulWidget {
  const SettingsList({super.key});

  @override
  State<SettingsList> createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  bool _darkMode = false;
  bool _notifications = true;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SwitchListTile(
          title: const Text('Dark mode'),
          subtitle: const Text('Use dark theme throughout the app'),
          value: _darkMode,
          onChanged: (v) => setState(() => _darkMode = v),
        ),
        SwitchListTile(
          title: const Text('Notifications'),
          subtitle: const Text('Receive push notifications'),
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        const AboutListTile(
          applicationName: 'QuickChat',
          applicationVersion: '1.0.0',
        ),
      ],
    );
  }
}
