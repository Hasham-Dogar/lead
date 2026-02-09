import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/data/lead_store.dart';
import 'package:leads/screens/contacts/contacts_page.dart';
import 'package:leads/screens/contacts/contact_detail_page.dart';
import 'package:leads/screens/home/widgets/home_header.dart';
import 'package:leads/screens/home/widgets/calendar_widget.dart';
import 'package:leads/screens/home/widgets/bottom_nav_bar.dart';
import 'package:leads/screens/create_contact/create_contact_page.dart';
import 'package:leads/screens/create_leads/create_leads_page.dart';
import 'package:leads/screens/leads/leads_page.dart';
import 'package:leads/screens/leads/lead_detail_page.dart';
import 'package:leads/screens/settings/settings.dart';
import 'package:leads/widgets/search/global_search_delegate.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _selectedNavIndex = 0;
  bool _isExpanded = false;
  late AnimationController _animationController;
  final List<Contact> _contacts = [];
  List<Lead> _leads = [];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Initialize leads from LeadStore
    _leads = LeadStore.instance.leads.value;

    // Listen to lead changes
    LeadStore.instance.leads.addListener(_onLeadsChanged);

    // Hardcoded contacts for testing
    _contacts.addAll([
      const Contact(
        id: '1',
        firstName: 'Abeer',
        lastName: 'Khan',
        phoneNumber: '3425678654',
        phoneCode: '92',
        email: 'abeerkhan11@gmail.com',
        note: 'Interested in Facebook Ads and SEO. Follow-up tomorrow 10 AM.',
      ),
      const Contact(
        id: '2',
        firstName: 'Leslie',
        lastName: 'Alexander',
        phoneNumber: '5551234567',
        phoneCode: '1',
        email: 'leslie.alexander@email.com',
        note: '',
      ),
      const Contact(
        id: '3',
        firstName: 'Devon',
        lastName: 'Lane',
        phoneNumber: '5559876543',
        phoneCode: '1',
        email: 'devon.lane@email.com',
        note: 'Looking for web development services',
      ),
      const Contact(
        id: '4',
        firstName: 'Jerome',
        lastName: 'Bell',
        phoneNumber: '5552223333',
        phoneCode: '1',
        email: 'jerome.bell@email.com',
        note: '',
      ),
    ]);
  }

  void _onLeadsChanged() {
    setState(() {
      _leads = LeadStore.instance.leads.value;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    LeadStore.instance.leads.removeListener(_onLeadsChanged);
    super.dispose();
  }

  void _toggleFABMenu() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rawFab = _buildFloatingActionButton();
    Widget? fab;
    if (rawFab != null) {
      if (_selectedNavIndex != 0) {
        fab = Positioned(bottom: 72, right: 24, child: rawFab);
      } else {
        fab = rawFab;
      }
    }
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(child: _buildBody()),
          bottomNavigationBar: BottomNavBar(
            selectedIndex: _selectedNavIndex,
            onTap: (index) {
              setState(() {
                _selectedNavIndex = index;
                if (_isExpanded) {
                  _isExpanded = false;
                  _animationController.reverse();
                }
              });
            },
          ),
        ),
        // Full-screen backdrop blur when FAB menu is expanded (covers nav bar)
        if (_isExpanded && _selectedNavIndex == 0)
          Positioned.fill(
            child: GestureDetector(
              onTap: _toggleFABMenu,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(color: Colors.black.withOpacity(0.25)),
              ),
            ),
          ),
        if (fab != null) fab,
      ],
    );
  }

  Widget _buildBody() {
    switch (_selectedNavIndex) {
      case 1:
        return ContactsPage(
          contacts: _contacts,
          onContactTap: _openContactDetail,
        );
      case 2:
        return LeadsPage(leads: _leads, contacts: _contacts);
      case 3:
        return const SettingsPage();
      default:
        return Column(
          children: [
            HomeHeader(onSearch: _openGlobalSearch),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CalendarWidget(leads: _leads),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
    }
  }

  Future<void> _openCreateContact() async {
    final contact = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (context) => const CreateContactPage()),
    );

    if (contact != null && mounted) {
      setState(() {
        _contacts.add(contact);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact added'),
          backgroundColor: Color(0xFFFC6060),
        ),
      );
    }
  }

  Future<void> _openContactDetail(Contact contact) async {
    final updated = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(
        builder: (context) => ContactDetailPage(contact: contact),
      ),
    );

    if (updated != null && mounted) {
      _replaceContact(updated);
    }
  }

  void _replaceContact(Contact updated) {
    final index = _contacts.indexWhere((c) => c.id == updated.id);
    if (index != -1) {
      setState(() {
        _contacts[index] = updated;
      });
    }
  }

  void _openGlobalSearch() {
    showSearch(
      context: context,
      delegate: GlobalSearchDelegate(
        leads: _leads,
        contacts: _contacts,
        onLeadTap: (lead) {
          final contact = _contacts.firstWhere(
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
                assignableContacts: _contacts,
                isManager: false,
                onLeadUpdate: (updated) {
                  final idx = _leads.indexWhere((l) => l.id == updated.id);
                  if (idx != -1) {
                    setState(() {
                      _leads[idx] = updated;
                    });
                  }
                },
              ),
            ),
          );
        },
        onContactTap: (contact) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ContactDetailPage(contact: contact),
            ),
          );
        },
      ),
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_selectedNavIndex == 1) {
      return FloatingActionButton(
        onPressed: _openCreateContact,
        backgroundColor: const Color(0xFFFC6060),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      );
    }

    // Leads page (index 2) handles its own FAB, so don't create one here
    if (_selectedNavIndex == 2) {
      return null;
    }

    if (_selectedNavIndex == 0) {
      return _buildFABMenu();
    }

    return null;
  }

  Widget _buildFABMenu() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        // Combined menu container with Lead and Contact
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          bottom: _isExpanded ? 180 : 96,
          right: _isExpanded ? 24 : 24,
          child: AnimatedOpacity(
            opacity: _isExpanded ? 1 : 0,
            duration: const Duration(milliseconds: 300),
            child: _isExpanded
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Lead option
                          InkWell(
                            onTap: () async {
                              _toggleFABMenu();
                              final newLead = await Navigator.of(context)
                                  .push<Lead>(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CreateLeadsPage(contacts: _contacts),
                                    ),
                                  );
                              if (newLead != null && mounted) {
                                setState(() {
                                  _leads.add(newLead);
                                });
                              }
                            },
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/leads.svg',
                                    width: 20,
                                    height: 20,
                                    color: Colors.grey.shade800,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Lead',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // Divider
                          Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.grey.shade200,
                          ),
                          // Contact option
                          InkWell(
                            onTap: () {
                              _toggleFABMenu();
                              _openCreateContact();
                            },
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/contacts.svg',
                                    width: 20,
                                    height: 20,
                                    color: Colors.grey.shade800,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Contact',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey.shade900,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
        // Main FAB button
        Positioned(
          bottom: 96,
          right: 24,
          child: FloatingActionButton(
            onPressed: _toggleFABMenu,
            backgroundColor: const Color(0xFFFC6060),
            elevation: 8,
            shape: const CircleBorder(),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _animationController.value * 3.14159,
                  child: Icon(
                    _isExpanded ? Icons.close : Icons.add,
                    color: Colors.white,
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
