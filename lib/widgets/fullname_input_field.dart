import 'package:flutter/material.dart';

class FullnameInputField extends StatefulWidget {
  const FullnameInputField({super.key});

  @override
  State<FullnameInputField> createState() => _FullnameInputFieldState();
}

class _FullnameInputFieldState extends State<FullnameInputField> {
  late TextEditingController _fullnameController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _fullnameController,
          decoration: InputDecoration(
            hintText: 'John Doe',
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: const Icon(
              Icons.person_outline,
              color: Colors.grey,
              size: 20,
            ),
            suffixIcon: const Icon(Icons.edit, color: Colors.grey, size: 18),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 12,
            ),
          ),
        ),
      ],
    );
  }
}
