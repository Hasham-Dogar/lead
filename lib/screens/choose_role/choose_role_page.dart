import 'package:flutter/material.dart';
import 'package:leads/data/user_session_store.dart';
import 'package:leads/screens/signup/signup_page.dart';
import 'package:leads/screens/choose_role/widgets/role_header.dart';
import 'package:leads/screens/choose_role/widgets/role_card.dart';
import 'package:leads/screens/choose_role/widgets/continue_button.dart';
import 'package:leads/screens/home/home_page.dart';
import 'package:leads/screens/team_manager_home/team_manager_home_page.dart';

class ChooseRolePage extends StatefulWidget {
  const ChooseRolePage({super.key, this.forSignup = false});

  final bool forSignup;

  @override
  State<ChooseRolePage> createState() => _ChooseRolePageState();
}

class _ChooseRolePageState extends State<ChooseRolePage> {
  String? _selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const RoleHeader(),
                const SizedBox(height: 48),
                RoleCard(
                  icon: 'assets/icons/member.png',
                  title: 'Member',
                  isSelected: _selectedRole == 'member',
                  onTap: () {
                    setState(() {
                      _selectedRole = 'member';
                    });
                  },
                ),
                const SizedBox(height: 24),
                RoleCard(
                  icon: 'assets/icons/team_manager.png',
                  title: 'Team Manager',
                  isSelected: _selectedRole == 'team_manager',
                  onTap: () {
                    setState(() {
                      _selectedRole = 'team_manager';
                    });
                  },
                ),
                const SizedBox(height: 48),
                ContinueButton(
                  isEnabled: _selectedRole != null,
                  onPressed: _selectedRole != null
                      ? () {
                          if (widget.forSignup) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignupPage(
                                  selectedRole: _selectedRole == 'team_manager'
                                      ? UserRole.teamManager
                                      : UserRole.member,
                                ),
                              ),
                            );
                            return;
                          }

                          // Navigate based on selected role
                          if (_selectedRole == 'member') {
                            UserSessionStore.instance.setMember(
                              isAssignedToTeam: false,
                            );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          } else if (_selectedRole == 'team_manager') {
                            UserSessionStore.instance.setTeamManager(
                              hasActivePaidPlan: false,
                            );
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => const TeamManagerHomePage(
                                  showPlanActivationDialog: true,
                                ),
                              ),
                            );
                          }
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
