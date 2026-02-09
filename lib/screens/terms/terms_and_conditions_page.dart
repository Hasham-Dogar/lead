import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Text(
                      'Terms and Conditions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: const Text(
                  'Lorem ipsum dolor sit amet consectetur. Placerat '
                  'sodales viverra eu ut curabitur. Est pellentesque '
                  'purus elementum nibh. Sed in mi mattis tellus. '
                  'Ultrices pellentesque amet lorem ornare. Sapien '
                  'ac libero fermentum erat. Arcu feugiat diam viverra '
                  'a eget eleifend adipiscing. Consequat arcu nec leo odio. '
                  'Pharetra neque odio sed aenean diam. Integer sed '
                  'feugiat consequat at tristique. Est laoreet blandit '
                  'quisque pellentesque elit. Non hendrerit sed felis '
                  'pellentesque sollicitudin non risus. Turpis viverra '
                  'consequat amet bibendum sagittis risus lorem eget. '
                  'At iaculis volutpat orci lorem. Auctor blandit nisl '
                  'pellentesque elementum elementum leo aliquam. Fringilla '
                  'elementum elementum volutpat convallis dignissim porttitor '
                  'velit arcu. Posuere tincidunt arcu iaculis lorem nisi '
                  'semper volutpat mauris. Vitae libero elementum proin in '
                  'lorem laoreet laoreet suscipit. Consectetur ultricies sed '
                  'arcu arcu pharetra. Ultrices vitae turpis amet. Scelerisque '
                  'pellentesque viverra sem tristique urna. Dictumst quam quis '
                  'tristique elementum vitae quis aenean turpis.'
                  '\n\n'
                  'Lorem ipsum dolor sit amet consectetur. Placerat sodales '
                  'viverra eu ut curabitur. Est pellentesque purus elementum '
                  'nibh. Sed in mi mattis tellus. Ultrices pellentesque amet '
                  'lorem ornare.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            // Footer Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF6B6B),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'I agree',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
