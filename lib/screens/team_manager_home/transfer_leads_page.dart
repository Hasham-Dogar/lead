import 'package:flutter/material.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/data/lead_store.dart';
import 'package:leads/data/notification_store.dart';

class TransferLeadsPage extends StatefulWidget {
  final Contact fromMember;
  final List<Contact> availableMembers;
  final List<Lead> leads;

  const TransferLeadsPage({
    super.key,
    required this.fromMember,
    required this.availableMembers,
    required this.leads,
  });

  @override
  State<TransferLeadsPage> createState() => _TransferLeadsPageState();
}

class _TransferLeadsPageState extends State<TransferLeadsPage> {
  final Set<String> _selectedLeadIds = {};
  Contact? _assignTo;
  int _step = 1; // 1 = select leads, 2 = select member

  @override
  void initState() {
    super.initState();
  }

  void _toggleLead(String id) {
    setState(() {
      if (_selectedLeadIds.contains(id)) {
        _selectedLeadIds.remove(id);
      } else {
        _selectedLeadIds.add(id);
      }
    });
  }

  void _goToStep2() {
    if (_selectedLeadIds.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select at least one lead')));
      return;
    }
    setState(() {
      _step = 2;
    });
  }

  void _assignLeads() {
    if (_assignTo == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Select a team member')));
      return;
    }

    // Update leads in the store
    final allLeads = LeadStore.instance.leads.value;
    final updatedLeads = allLeads.map((lead) {
      if (_selectedLeadIds.contains(lead.id)) {
        // Create notification for each transferred lead
        NotificationStore.instance.notifyLeadAssigned(
          lead.title,
          lead.id,
          _assignTo!.fullName,
        );

        return lead.copyWith(
          contactId: _assignTo!.id,
          contactName: _assignTo!.fullName,
        );
      }
      return lead;
    }).toList();

    LeadStore.instance.leads.value = updatedLeads;

    // Return true to indicate successful transfer
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: Text(
          _step == 1 ? widget.fromMember.fullName : 'Assign Leads',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: _step == 1 ? _buildLeadSelection() : _buildMemberSelection(),
    );
  }

  Widget _buildLeadSelection() {
    return Column(
      children: [
        if (_selectedLeadIds.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.grey.shade50,
            child: Row(
              children: [
                Text(
                  'Selected: ${_selectedLeadIds.length}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: widget.leads.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final lead = widget.leads[index];
              final isSelected = _selectedLeadIds.contains(lead.id);
              return _LeadSelectionTile(
                lead: lead,
                isSelected: isSelected,
                onToggle: () => _toggleLead(lead.id),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _goToStep2,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC6060),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMemberSelection() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: widget.availableMembers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final member = widget.availableMembers[index];
              final isSelected = _assignTo?.id == member.id;
              return InkWell(
                onTap: () => setState(() => _assignTo = member),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFC6060)
                          : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        member.fullName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFFFC6060)
                                : Colors.grey.shade400,
                            width: 1.2,
                          ),
                          color: isSelected
                              ? const Color(0xFFFFF0F0)
                              : Colors.white,
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 16,
                                color: Color(0xFFFC6060),
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _assignLeads,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFC6060),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Assign',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LeadSelectionTile extends StatelessWidget {
  final Lead lead;
  final bool isSelected;
  final VoidCallback onToggle;

  const _LeadSelectionTile({
    required this.lead,
    required this.isSelected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300, width: 1),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lead.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${lead.dateTime.day} ${_getMonthName(lead.dateTime.month)}, ${lead.dateTime.year} | ${lead.dateTime.hour.toString().padLeft(2, '0')}:${lead.dateTime.minute.toString().padLeft(2, '0')} ${lead.dateTime.hour >= 12 ? 'PM' : 'AM'}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 245, 245),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xFFFC6060),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.person,
                              size: 14,
                              color: Colors.black,
                            ),
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
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFFFC6060)
                      : Colors.grey.shade400,
                  width: 1.2,
                ),
                color: isSelected ? const Color(0xFFFFF0F0) : Colors.white,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Color(0xFFFC6060))
                  : null,
            ),
          ],
        ),
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
