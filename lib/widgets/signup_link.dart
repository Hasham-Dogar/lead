import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:leads/screens/signup/signup_page.dart';

class SignupLink extends StatelessWidget {
  const SignupLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: "Don't have an account? ",
          style: const TextStyle(
            fontSize: 13,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: 'Create new account!',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
