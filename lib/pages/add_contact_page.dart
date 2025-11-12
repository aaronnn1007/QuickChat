import 'package:flutter/material.dart';
import '../widgets/add_contact/add_contact_form.dart';

class AddContactPage extends StatelessWidget {
  const AddContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Contact')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: AddContactForm(),
      ),
    );
  }
}
