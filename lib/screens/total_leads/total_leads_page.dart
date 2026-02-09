import 'package:flutter/material.dart';
import 'package:leads/screens/total_leads/widgets/lead_card.dart';

class TotalLeadsPage extends StatelessWidget {
  const TotalLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Total Leads',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          LeadCard(
            title: 'Leads management system',
            date: '20 Aug, 2025 | 12:20 PM',
            assignee: 'Abeer khan',
          ),
          SizedBox(height: 12),
          LeadCard(
            title: 'Call for follow-up',
            date: '18 Aug, 2025 | 10:20 AM',
            assignee: 'Devon Lane',
          ),
          SizedBox(height: 12),
          LeadCard(
            title: 'Payment reminder',
            date: '10 Aug, 2025 | 01:20 PM',
            assignee: 'Jerome Bell',
          ),
          SizedBox(height: 12),
          LeadCard(
            title: 'Leads management system',
            date: '20 Aug, 2025 | 12:20 PM',
            assignee: 'Abeer khan',
          ),
          SizedBox(height: 12),
          LeadCard(
            title: 'Call for follow-up',
            date: '18 Aug, 2025 | 10:20 AM',
            assignee: 'Devon Lane',
          ),
        ],
      ),
    );
  }
}
