import 'package:flutter/material.dart';
import 'package:leads/widgets/notification_icon_button.dart';

class HomeHeader extends StatelessWidget {
  final VoidCallback onSearch;
  const HomeHeader({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Home',
                style: TextStyle(
                  fontFamily: 'Pacifico',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: onSearch,
                    child: const Icon(Icons.search, color: Colors.black87),
                  ),
                  const SizedBox(width: 16),
                  const NotificationIconButton(),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
