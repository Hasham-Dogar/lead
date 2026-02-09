import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/data/lead_store.dart';
import 'package:leads/screens/leads/leads_list_page.dart';
import 'package:leads/screens/team_manager_home/transfer_leads_page.dart';

class TeamPage extends StatefulWidget {
  final List<Contact> teamMembers;
  final VoidCallback onAddTap;
  final ValueChanged<Contact> onRemoveMember;

  const TeamPage({
    super.key,
    required this.teamMembers,
    required this.onAddTap,
    required this.onRemoveMember,
  });

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  final Set<String> _showDeleteFor = {};

  void _toggleDelete(String id) {
    setState(() {
      if (_showDeleteFor.contains(id)) {
        _showDeleteFor.remove(id);
      } else {
        _showDeleteFor.add(id);
      }
    });
  }

  void _confirmRemove(Contact contact) {
    _showRemoveDialog(contact);
  }

  void _showRemoveDialog(Contact contact) {
    final allLeads = LeadStore.instance.leads.value;
    final contactLeads = allLeads
        .where((l) => l.contactId == contact.id)
        .toList();
    final otherMembers = widget.teamMembers
        .where((m) => m.id != contact.id)
        .toList();

    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(
                      Icons.close,
                      size: 22,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                SvgPicture.asset(
                  'assets/icons/delete.svg',
                  width: 50,
                  height: 50,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Remove?',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Assign this user's leads to another team member before removing them.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFC6060),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: () async {
                            if (contactLeads.isEmpty) {
                              widget.onRemoveMember(contact);
                              setState(() {
                                _showDeleteFor.remove(contact.id);
                              });
                              Navigator.pop(ctx);
                              return;
                            }

                            if (otherMembers.isEmpty) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Add another team member to transfer leads.',
                                  ),
                                  backgroundColor: Color(0xFFFC6060),
                                ),
                              );
                              return;
                            }

                            Navigator.pop(ctx);
                            final transferred = await Navigator.of(context)
                                .push<bool>(
                                  MaterialPageRoute(
                                    builder: (_) => TransferLeadsPage(
                                      fromMember: contact,
                                      availableMembers: otherMembers,
                                      leads: contactLeads,
                                    ),
                                  ),
                                );

                            if (transferred == true && mounted) {
                              widget.onRemoveMember(contact);
                              setState(() {
                                _showDeleteFor.remove(contact.id);
                              });
                            }
                          },
                          child: const Text(
                            'Assign',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: 44,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFC6060)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            if (contactLeads.isNotEmpty) {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Transfer leads to another member before deleting.',
                                  ),
                                  backgroundColor: Color(0xFFFC6060),
                                ),
                              );
                              return;
                            }

                            widget.onRemoveMember(contact);
                            setState(() {
                              _showDeleteFor.remove(contact.id);
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Delete',
                            style: TextStyle(
                              color: Color(0xFFFC6060),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openContactLeads(Contact contact) {
    final allLeads = LeadStore.instance.leads.value;
    final contactLeads = allLeads
        .where((l) => l.contactId == contact.id)
        .toList();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            title: Text(
              contact.fullName,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: LeadsListPage(
            leads: contactLeads,
            contacts: widget.teamMembers,
            assignableContacts: widget.teamMembers,
            isManager: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasMembers = widget.teamMembers.isNotEmpty;
    return Stack(
      children: [
        Positioned.fill(
          child: hasMembers
              ? ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemBuilder: (context, index) {
                    final contact = widget.teamMembers[index];
                    final showDelete = _showDeleteFor.contains(contact.id);
                    return _TeamMemberTile(
                      contact: contact,
                      showDelete: showDelete,
                      onToggleDelete: () => _toggleDelete(contact.id),
                      onDelete: () => _confirmRemove(contact),
                      onOpen: () => _openContactLeads(contact),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemCount: widget.teamMembers.length,
                )
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/empty.png',
                        width: 180,
                        height: 180,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Team yet!',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
        ),
        Positioned(
          bottom: 24,
          right: 24,
          child: FloatingActionButton(
            onPressed: widget.onAddTap,
            backgroundColor: const Color(0xFFFC6060),
            shape: const CircleBorder(),
            heroTag: 'teamFab',
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _TeamMemberTile extends StatelessWidget {
  final Contact contact;
  final bool showDelete;
  final VoidCallback onToggleDelete;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  const _TeamMemberTile({
    required this.contact,
    required this.showDelete,
    required this.onToggleDelete,
    required this.onDelete,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              onTap: onOpen,
              child: Text(
                contact.fullName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Color(0xFF999999),
                ),
                onPressed: onToggleDelete,
              ),
              if (showDelete)
                IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    size: 18,
                    color: Color(0xFFFC6060),
                  ),
                  onPressed: onDelete,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
