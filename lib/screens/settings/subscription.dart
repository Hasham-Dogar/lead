import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  static const Color _accentColor = Color(0xFFFC6060);
  static const Color _pageColor = Color(0xFFFFFFFF);
  static const Color _cardBorderColor = Color(0xFFBFBFBF);
  static const Color _mutedTextColor = Color(0xFF666666);
  static const Color _titleColor = Colors.black;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

enum PlanType { free, pro, team }

class _SubscriptionPageState extends State<SubscriptionPage> {
  PlanType _selected = PlanType.free;
  PlanType? _expanded;

  void _select(PlanType plan) {
    setState(() {
      _selected = plan;
      _expanded = plan;
    });
  }

  void _toggleExpand(PlanType plan) {
    setState(() {
      _expanded = _expanded == plan ? null : plan;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SubscriptionPage._pageColor,
      appBar: AppBar(
        backgroundColor: SubscriptionPage._pageColor,
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
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              PlanCard(
                title: 'Free',
                price: '\$0',
                subtitle: 'Up to 5 team member',
                features: const [
                  '5 projects',
                  '1 GB storage',
                  'Community support',
                  'Analytics',
                  'Priority access',
                ],
                isActive: _selected == PlanType.free,
                isExpanded: _expanded == PlanType.free,
                onTap: () => _toggleExpand(PlanType.free),
                onToggleExpand: () => _toggleExpand(PlanType.free),
                onSelect: () => setState(() => _selected = PlanType.free),
              ),
              const SizedBox(height: 18),
              PlanCard(
                title: 'Pro',
                price: '\$12',
                subtitle: 'Up to 20 team member',
                features: const [
                  'Unlimited projects',
                  '50 GB storage',
                  'Priority support',
                  'Full analytics',
                  'Up to 5 team seats',
                ],
                isActive: _selected == PlanType.pro,
                isExpanded: _expanded == PlanType.pro,
                onTap: () => _toggleExpand(PlanType.pro),
                onToggleExpand: () => _toggleExpand(PlanType.pro),
                onSelect: () => setState(() => _selected = PlanType.pro),
              ),
              const SizedBox(height: 18),
              PlanCard(
                title: 'Team',
                price: '\$29',
                subtitle: 'Up to 100 team member',
                features: const [
                  'Unlimited projects',
                  '500 GB storage',
                  'Dedicated support',
                  'Advanced analytics',
                  'Up to 25 team seats',
                ],
                isActive: _selected == PlanType.team,
                isExpanded: _expanded == PlanType.team,
                onTap: () => _toggleExpand(PlanType.team),
                onToggleExpand: () => _toggleExpand(PlanType.team),
                onSelect: () => setState(() => _selected = PlanType.team),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.subtitle,
    required this.features,
    this.isActive = false,
    this.isExpanded = false,
    required this.onTap,
    required this.onToggleExpand,
    required this.onSelect,
  });

  final String title;
  final String price;
  final String subtitle;
  final List<String> features;
  final bool isActive;
  final bool isExpanded;
  final VoidCallback onTap;
  final VoidCallback onToggleExpand;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final borderColor = isActive
        ? SubscriptionPage._accentColor
        : SubscriptionPage._cardBorderColor;

    final bgColor = isActive
        ? const Color(0xFFFEF4F3) // rgb(254,244,243)
        : Colors.white;

    return Material(
      color: bgColor,
      elevation: isActive ? 2 : 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: SubscriptionPage._titleColor,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  price,
                                  style: const TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.w700,
                                    color: SubscriptionPage._titleColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 6),
                                  child: Text(
                                    '/mo',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: SubscriptionPage._mutedTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: SubscriptionPage._mutedTextColor,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: onToggleExpand,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: SubscriptionPage._mutedTextColor,
                            size: 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (isExpanded) ...[
                    const SizedBox(height: 14),
                    for (final f in features)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          f,
                          style: TextStyle(
                            color: SubscriptionPage._mutedTextColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    if (!isActive)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: onSelect,
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: SubscriptionPage._accentColor,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Select',
                              style: TextStyle(
                                color: SubscriptionPage._accentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ],
              ),
            ),
            if (isActive)
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF7B7B), Color(0xFFFC6060)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: const [
                      Text(
                        'Currently Active',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.check_circle, color: Colors.white, size: 18),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
