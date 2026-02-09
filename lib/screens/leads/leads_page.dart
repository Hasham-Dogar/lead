import 'package:flutter/material.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/screens/leads/lead_detail_page.dart';
import 'package:leads/screens/leads/leads_list_page.dart';
import 'package:leads/widgets/notification_icon_button.dart';
import 'package:leads/widgets/search/global_search_delegate.dart';

class LeadsPage extends StatelessWidget {
  final List<Lead> leads;
  final List<Contact> contacts;

  const LeadsPage({super.key, required this.leads, required this.contacts});

  void _openGlobalSearch(BuildContext context) {
    showSearch(
      context: context,
      delegate: GlobalSearchDelegate(
        leads: leads,
        contacts: contacts,
        onLeadTap: (lead) {
          final contact = contacts.firstWhere(
            (c) => c.id == lead.contactId,
            orElse: () => Contact(
              id: lead.contactId,
              firstName: lead.contactName,
              lastName: '',
              phoneNumber: '',
              phoneCode: '92',
              email: '',
              note: '',
            ),
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => LeadDetailPage(
                lead: lead,
                contact: contact,
                assignableContacts: contacts,
                isManager: false,
                onLeadUpdate: (_) {},
              ),
            ),
          );
        },
        onContactTap: (_) {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Leads',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87),
            onPressed: () => _openGlobalSearch(context),
          ),
          const NotificationIconButton(),
        ],
      ),
      body: LeadsListPage(leads: leads, contacts: contacts, showFAB: true),
    );
  }
}
