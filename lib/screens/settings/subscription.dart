import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  static const Color _accentColor = Color(0xFFFC6060);
  static const Color _pageColor = Color(0xFFF4F4F4);
  static const Color _cardBorderColor = Color(0xFFB0B0B0);
  static const Color _mutedTextColor = Color(0xFF666666);
  static const Color _titleColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageColor,
      appBar: AppBar(
        backgroundColor: _pageColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Subscription',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 70),
              _buildFreePlanCard(),
              const SizedBox(height: 22),
              _buildPrimaryButton(
                label: 'Get started',
                onTap: () => _showMessage(context, 'Free plan selected'),
              ),
              const SizedBox(height: 22),
              _buildFeaturesCard(
                features: const [
                  'Unlimited projects',
                  '50 GB storage',
                  'Priority support',
                  'Full analytics',
                  'Team seats',
                ],
              ),
              const SizedBox(height: 22),
              _buildOutlinedButton(
                label: 'Subscribe to Pro',
                onTap: () => _showMessage(context, 'Pro plan selected'),
              ),
              const SizedBox(height: 22),
              _buildFeaturesCard(
                features: const [
                  'Unlimited projects',
                  '500 GB storage',
                  'Dedicated support',
                  'Advanced analytics',
                  'Up to 25 seats',
                ],
              ),
              const SizedBox(height: 22),
              _buildOutlinedButton(
                label: 'Contact sales',
                onTap: () => _showMessage(context, 'Sales contact requested'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFreePlanCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 18, 20, 18),
      decoration: BoxDecoration(
        color: _pageColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _cardBorderColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Free',
                  style: TextStyle(
                    fontSize: 44 / 3,
                    fontWeight: FontWeight.w500,
                    color: _titleColor,
                  ),
                ),
                SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$0',
                      style: TextStyle(
                        fontSize: 60 / 3,
                        fontWeight: FontWeight.w500,
                        height: 1,
                        color: _titleColor,
                      ),
                    ),
                    SizedBox(width: 4),
                    Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        '/mo',
                        style: TextStyle(
                          fontSize: 14,
                          color: _mutedTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 18),
                Text(
                  'Get Started with the\nbasic, no card\nneeded',
                  style: TextStyle(
                    fontSize: 19 / 1.3,
                    color: _mutedTextColor,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: _FeatureList(
              features: [
                '5 projects',
                '1 GB storage',
                'Community support',
                'Analytics',
                'Priority access',
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard({required List<String> features}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
      decoration: BoxDecoration(
        color: _pageColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _cardBorderColor, width: 2),
      ),
      child: Row(
        children: [
          const Spacer(),
          Expanded(flex: 3, child: _FeatureList(features: features)),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 92,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          elevation: 6,
          shadowColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 22 / 1.25,
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: onTap,
        child: Text(label),
      ),
    );
  }

  Widget _buildOutlinedButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 92,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: _titleColor,
          backgroundColor: _pageColor,
          side: const BorderSide(color: _titleColor, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: const TextStyle(
            fontSize: 22 / 1.25,
            fontWeight: FontWeight.w700,
          ),
        ),
        child: Text(label),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _FeatureList extends StatelessWidget {
  const _FeatureList({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final feature in features)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3.5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  margin: const EdgeInsets.only(top: 5, right: 10),
                  decoration: const BoxDecoration(
                    color: SubscriptionPage._accentColor,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    feature,
                    style: const TextStyle(
                      color: SubscriptionPage._mutedTextColor,
                      fontSize: 36 / 3,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
