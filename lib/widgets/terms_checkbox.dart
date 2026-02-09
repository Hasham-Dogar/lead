import 'package:flutter/material.dart';
import 'package:leads/screens/terms/terms_and_conditions_page.dart';

class TermsCheckbox extends StatefulWidget {
  const TermsCheckbox({super.key});

  @override
  State<TermsCheckbox> createState() => _TermsCheckboxState();
}

class _TermsCheckboxState extends State<TermsCheckbox> {
  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: _agreedToTerms,
          onChanged: (value) {
            setState(() {
              _agreedToTerms = value ?? false;
            });
          },
          activeColor: const Color.fromARGB(255, 252, 96, 96),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsAndConditionsPage(),
                ),
              );
            },
            child: RichText(
              text: const TextSpan(
                text: 'I agree to ',
                style: TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(221, 121, 121, 121),
                  fontWeight: FontWeight.w400,
                ),
                children: [
                  TextSpan(
                    text: 'Terms and conditions',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color.fromARGB(255, 121, 121, 121),
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
