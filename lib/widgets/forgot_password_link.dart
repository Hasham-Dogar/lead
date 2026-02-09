import 'package:flutter/material.dart';

class ForgotPasswordLink extends StatelessWidget {
  const ForgotPasswordLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          // TODO: Implement forgot password functionality
        },
        child: const Text(
          'Forgot Password?',
          style: TextStyle(
            fontSize: 12,
            color: Colors.red,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
