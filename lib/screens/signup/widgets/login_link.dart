import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:leads/screens/login/login_page.dart';

class LoginLink extends StatelessWidget {
  const LoginLink({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Already have an Account? ',
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
          ),
          children: [
            TextSpan(
              text: 'Login',
              style: const TextStyle(
                fontSize: 12,
                color: Color.fromARGB(255, 252, 96, 96),
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
            ),
          ],
        ),
      ),
    );
  }
}
