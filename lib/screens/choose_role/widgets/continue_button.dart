import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final bool isEnabled;
  final VoidCallback? onPressed;

  const ContinueButton({super.key, required this.isEnabled, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? const Color(0xFFFC6060)
              : Colors.grey.shade300,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          disabledBackgroundColor: Colors.grey.shade300,
        ),
        child: Text(
          'Continue',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isEnabled ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }
}
