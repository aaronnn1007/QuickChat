import 'package:flutter/material.dart';

class AddContactForm extends StatefulWidget {
  const AddContactForm({super.key});

  @override
  State<AddContactForm> createState() => _AddContactFormState();
}

class _AddContactFormState extends State<AddContactForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _handleController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _handleController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // For now just pop with data placeholder
      Navigator.pop(context, {
        'name': _nameController.text.trim(),
        'handle': _handleController.text.trim(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Display name'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter a name' : null,
          ),
          TextFormField(
            controller: _handleController,
            decoration: const InputDecoration(labelText: 'Handle (@username)'),
            validator: (v) => v == null || v.trim().isEmpty ? 'Enter a handle' : null,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _submit,
            icon: const Icon(Icons.save),
            label: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
