import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Privacy Policy',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: const Text(
                  'Lorem ipsum dolor sit amet consectetur. Placerat sodales viverra eu ut curabitur. Est pellentesque purus elementum nibh. Sed in mi mattis tellus. Ultrices pellentesque amet lorem ornare. Sapien ac libero fermentum erat. Arcu feugiat diam viverra a eget eleifend adipiscing. Consequat arcu nec leo odio. Pharetra neque odio sed aenean diam. Integer sed feugiat consequat at tristique. Est laoreet blandit quisque pellentesque elit. Non hendrerit sed felis pellentesque sollicitudin non risus. Turpis viverra consequat amet bibendum sagittis risus lorem eget. At iaculis volutpat orci lorem. Auctor blandit nisl pellentesque elementum elementum leo aliquam. Fringilla elementum elementum volutpat convallis dignissim porttitor velit arcu. Posuere tincidunt arcu iaculis lorem nisi semper volutpat mauris. Vitae libero elementum proin in lorem laoreet laoreet suscipit. Consectetur ultricies sed arcu arcu pharetra. Ultrices vitae turpis amet. Scelerisque pellentesque viverra sem tristique urna. Dictumst quam quis tristique elementum vitae quis aenean turpis.\n\nLorem ipsum dolor sit amet consectetur. Placerat sodales viverra eu ut curabitur. Est pellentesque purus elementum nibh. Sed in mi mattis tellus. Ultrices pellentesque amet lorem ornare. Sapien ac libero fermentum erat. Arcu feugiat diam viverra a eget eleifend adipiscing. Consequat arcu nec leo odio. Pharetra neque odio sed aenean diam. Integer sed feugiat consequat at tristique. Est laoreet blandit quisque pellentesque elit. Non hendrerit sed felis pellentesque sollicitudin non risus. Turpis viverra consequat amet bibendum sagittis risus lorem eget. At iaculis volutpat orci lorem. Auctor blandit nisl pellentesque elementum elementum leo aliquam. Fringilla elementum elementum volutpat convallis dignissim porttitor velit arcu. Posuere tincidunt arcu iaculis lorem nisi semper volutpat mauris. Vitae libero elementum proin in lorem laoreet laoreet suscipit. Consectetur ultricies sed arcu arcu pharetra. Ultrices vitae turpis amet. Scelerisque pellentesque viverra sem tristique urna. Dictumst quam quis tristique elementum vitae quis aenean turpis.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF444444),
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFC6060),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'I agree',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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
