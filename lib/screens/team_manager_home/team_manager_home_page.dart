import 'package:flutter/material.dart';
import 'package:leads/data/lead_store.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/screens/contacts/contact_detail_page.dart';
import 'package:leads/screens/home/widgets/bottom_nav_bar.dart';
import 'package:leads/screens/leads/lead_detail_page.dart';
import 'package:leads/screens/leads/leads_list_page.dart';
import 'package:leads/screens/settings/settings.dart';
import 'package:leads/screens/team_manager_home/widgets/stats_card.dart';
import 'package:leads/screens/team_manager_home/team_page.dart';
import 'package:leads/screens/team_manager_home/add_team_member_page.dart';
import 'package:leads/widgets/notification_icon_button.dart';
import 'package:leads/widgets/search/global_search_delegate.dart';

class TeamManagerHomePage extends StatefulWidget {
  const TeamManagerHomePage({super.key});

  @override
  State<TeamManagerHomePage> createState() => _TeamManagerHomePageState();
}

class _TeamManagerHomePageState extends State<TeamManagerHomePage> {
  int _selectedNavIndex = 0;
  final List<Contact> _teamMembers = [];
  final List<Contact> _allContacts = [
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
  ];

  void _navigateToTotalLeads() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
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
          body: LeadsListPage(
            leads: LeadStore.instance.leads.value,
            contacts: _allContacts,
            showTabs: false,
          ),
        ),
      ),
    );
  }

  void _navigateToActiveLeads(List<Lead> leads) {
    final today = DateTime.now();
    final activeLeads = leads
        .where(
          (lead) =>
              lead.dateTime.year == today.year &&
              lead.dateTime.month == today.month &&
              lead.dateTime.day == today.day,
        )
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Active Leads Today',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: LeadsListPage(
            leads: activeLeads,
            contacts: _allContacts,
            showTabs: false,
          ),
        ),
      ),
    );
  }

  void _navigateToPendingLeads(List<Lead> leads) {
    final pendingLeads = leads
        .where((lead) => lead.status == LeadStatus.pending)
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Pending Leads',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: LeadsListPage(
            leads: pendingLeads,
            contacts: _allContacts,
            showTabs: false,
          ),
        ),
      ),
    );
  }

  void _navigateToCompletedLeads(List<Lead> leads) {
    final completedLeads = leads
        .where((lead) => lead.status == LeadStatus.completed)
        .toList();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              'Completed Leads',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            centerTitle: true,
          ),
          body: LeadsListPage(
            leads: completedLeads,
            contacts: _allContacts,
            showTabs: false,
          ),
        ),
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
        title: Text(
          _getAppBarTitle(),
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: _openGlobalSearch,
          ),
          const NotificationIconButton(),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<List<Lead>>(
          valueListenable: LeadStore.instance.leads,
          builder: (context, leads, _) => _buildBody(leads),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedNavIndex,
        secondItemLabel: 'Team',
        onTap: (index) {
          setState(() {
            _selectedNavIndex = index;
          });
        },
      ),
    );
  }

  void _openGlobalSearch() {
    final leads = LeadStore.instance.leads.value;

    showSearch(
      context: context,
      delegate: GlobalSearchDelegate(
        leads: leads,
        contacts: _allContacts,
        onLeadTap: (lead) {
          final contact = _allContacts.firstWhere(
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
                assignableContacts: _allContacts,
                isManager: true,
                onLeadUpdate: (updated) {
                  final current = LeadStore.instance.leads.value;
                  final idx = current.indexWhere((l) => l.id == updated.id);
                  if (idx != -1) {
                    final updatedLeads = List<Lead>.from(current);
                    updatedLeads[idx] = updated;
                    LeadStore.instance.leads.value = updatedLeads;
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

  Widget _buildBody(List<Lead> leads) {
    switch (_selectedNavIndex) {
      case 1:
        return TeamPage(
          teamMembers: _teamMembers,
          onAddTap: _openAddTeamMember,
          onRemoveMember: _removeTeamMember,
        );
      case 2:
        return LeadsListPage(
          leads: leads,
          contacts: _allContacts,
          showFAB: true,
        );
      case 3:
        return const SettingsPage();
      default:
        return _buildStatsGrid(leads);
    }
  }

  Widget _buildStatsGrid(List<Lead> leads) {
    final today = DateTime.now();
    final total = leads.length;
    final activeToday = leads
        .where(
          (lead) =>
              lead.dateTime.year == today.year &&
              lead.dateTime.month == today.month &&
              lead.dateTime.day == today.day,
        )
        .length;
    final pending = leads
        .where((lead) => lead.status == LeadStatus.pending)
        .length;
    final completed = leads
        .where((lead) => lead.status == LeadStatus.completed)
        .length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  iconPath: 'assets/total_leads.png',
                  value: '$total',
                  label: 'Total Leads',
                  onTap: _navigateToTotalLeads,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatsCard(
                  iconPath: 'assets/active_leads.png',
                  value: '$activeToday',
                  label: 'Active Leads\nToday',
                  onTap: () => _navigateToActiveLeads(leads),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: StatsCard(
                  iconPath: 'assets/Pending_leads.png',
                  value: '$pending',
                  label: 'Pending\nLeads',
                  onTap: () => _navigateToPendingLeads(leads),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: StatsCard(
                  iconPath: 'assets/completed_leads.png',
                  value: '$completed',
                  label: 'Completed\nLeads',
                  onTap: () => _navigateToCompletedLeads(leads),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedNavIndex) {
      case 1:
        return 'Team';
      case 2:
        return 'Leads';
      case 3:
        return 'Settings';
      default:
        return 'Home';
    }
  }

  Future<void> _openAddTeamMember() async {
    final selected = await Navigator.of(context).push<List<Contact>>(
      MaterialPageRoute(
        builder: (_) => AddTeamMemberPage(
          contacts: _allContacts,
          existingMembers: _teamMembers,
        ),
      ),
    );

    if (selected != null && selected.isNotEmpty && mounted) {
      setState(() {
        _teamMembers.addAll(selected);
      });
    }
  }

  void _removeTeamMember(Contact contact) {
    setState(() {
      _teamMembers.removeWhere((c) => c.id == contact.id);
    });
  }
}
