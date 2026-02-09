import 'package:flutter/material.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/screens/leads/lead_detail_page.dart';
import 'package:leads/screens/create_leads/create_leads_page.dart';

class LeadsListPage extends StatefulWidget {
  final List<Lead>? leads;
  final List<Contact>? contacts;
  final List<Contact>? assignableContacts;
  final bool showFAB;
  final bool showTabs;
  final bool isManager;

  const LeadsListPage({
    super.key,
    this.leads,
    this.contacts,
    this.assignableContacts,
    this.showFAB = false,
    this.showTabs = true,
    this.isManager = false,
  });

  @override
  State<LeadsListPage> createState() => _LeadsListPageState();
}

class _LeadsListPageState extends State<LeadsListPage> {
  late List<Lead> _allLeads;
  late LeadStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _allLeads = widget.leads ?? [];
    _selectedStatus = LeadStatus.pending;
  }

  @override
  void didUpdateWidget(LeadsListPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update the leads list when the widget is rebuilt with new data
    if (widget.leads != oldWidget.leads) {
      setState(() {
        _allLeads = widget.leads ?? [];
      });
    }
  }

  List<Lead> get _filteredLeads {
    if (!widget.showTabs) {
      return _allLeads;
    }
    return _allLeads.where((lead) => lead.status == _selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            // Status tabs
            if (widget.showTabs)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildStatusTab(LeadStatus.pending),
                    _buildStatusTab(LeadStatus.rescheduled),
                    _buildStatusTab(LeadStatus.completed),
                  ],
                ),
              ),
            // Leads list
            Expanded(
              child: _filteredLeads.isEmpty
                  ? Center(
                      child: Text(
                        widget.showTabs
                            ? 'No ${_selectedStatus.displayName.toLowerCase()} leads'
                            : 'No leads',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: _filteredLeads.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final lead = _filteredLeads[index];
                        final contact = widget.contacts?.firstWhere(
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
                        return _LeadCard(
                          lead: lead,
                          onViewDetail: () {
                            Navigator.of(context).push<Lead>(
                              MaterialPageRoute(
                                builder: (context) => LeadDetailPage(
                                  lead: lead,
                                  contact: contact,
                                  assignableContacts:
                                      widget.assignableContacts ??
                                      widget.contacts,
                                  isManager: widget.isManager,
                                  onLeadUpdate: (updatedLead) {
                                    setState(() {
                                      final leadIndex = _allLeads.indexWhere(
                                        (l) => l.id == lead.id,
                                      );
                                      if (leadIndex != -1) {
                                        _allLeads[leadIndex] = updatedLead;
                                      }
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        if (widget.showFAB)
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => CreateLeadsPage(contacts: widget.contacts),
                  ),
                );
              },
              backgroundColor: const Color(0xFFFC6060),
              shape: const CircleBorder(),
              heroTag: 'leadsFab',
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
      ],
    );
  }

  Widget _buildStatusTab(LeadStatus status) {
    final isSelected = _selectedStatus == status;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedStatus = status;
        });
      },
      child: Column(
        children: [
          Text(
            status.displayName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFFFC6060) : Colors.grey,
            ),
          ),
          if (isSelected)
            Container(
              height: 2,
              width: 40,
              margin: const EdgeInsets.only(top: 8),
              color: const Color(0xFFFC6060),
            ),
        ],
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  final Lead lead;
  final VoidCallback onViewDetail;

  const _LeadCard({required this.lead, required this.onViewDetail});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            lead.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          // Date and time
          Text(
            '${lead.dateTime.day} ${_getMonthName(lead.dateTime.month)} ${lead.dateTime.year} | ${lead.dateTime.hour.toString().padLeft(2, '0')}:${lead.dateTime.minute.toString().padLeft(2, '0')} ${lead.dateTime.hour >= 12 ? 'PM' : 'AM'}',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 12),
          // Contact tag and view detail button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFC6060), Color(0xFFFF8A80)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(1.5),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, size: 14, color: Colors.black),
                      const SizedBox(width: 6),
                      Text(
                        lead.contactName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: onViewDetail,
                child: const Text(
                  'View detail',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    decorationColor: Color(0xFFFC6060),
                    decorationThickness: 2,
                    fontSize: 12,
                    color: Color(0xFFFC6060),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}
