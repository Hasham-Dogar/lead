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
  const TeamManagerHomePage({super.key, this.showPlanActivationDialog = false});

  final bool showPlanActivationDialog;

  @override
  State<TeamManagerHomePage> createState() => _TeamManagerHomePageState();
}

class _TeamManagerHomePageState extends State<TeamManagerHomePage> {
  static const Color _settingsBackgroundColor = Colors.white;

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

  @override
  void initState() {
    super.initState();

    if (widget.showPlanActivationDialog) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        _showNoActivePlanDialog();
      });
    }
  }

  Future<void> _showNoActivePlanDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          backgroundColor: const Color(0xFFF2F2F7),
          surfaceTintColor: const Color(0xFFF2F2F7),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(dialogContext),
                    child: const Icon(
                      Icons.close,
                      size: 48,
                      color: Color(0xFF3C3C43),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 108,
                  color: Colors.black,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Not Assigned Yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Please Contact Support Team To Active Your Plan',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                    color: Color(0xFF666666),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 62,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFC6060),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(dialogContext),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
    final bodyContent = ValueListenableBuilder<List<Lead>>(
      valueListenable: LeadStore.instance.leads,
      builder: (context, leads, _) => _buildBody(leads),
    );

    return Scaffold(
      backgroundColor: _selectedNavIndex == 3
          ? _settingsBackgroundColor
          : Colors.white,
      appBar: _selectedNavIndex == 3
          ? null
          : AppBar(
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
      body: _selectedNavIndex == 3 ? bodyContent : SafeArea(child: bodyContent),
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
        return const SettingsPage(isTeamManager: true);
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
