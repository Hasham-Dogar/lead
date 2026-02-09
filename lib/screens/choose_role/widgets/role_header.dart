import 'package:flutter/material.dart';

class RoleHeader extends StatelessWidget {
  const RoleHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(
                Icons.arrow_back,
                size: 24,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Choose Role',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose how you want to continue – manage your team as an Admin or add leads as a User.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
