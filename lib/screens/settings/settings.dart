import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leads/screens/settings/profile.dart';
import 'package:leads/screens/settings/change_password.dart';
import 'package:leads/screens/settings/privacy.dart';
import 'package:leads/screens/settings/terms_conditions.dart';
import 'package:leads/widgets/notification_icon_button.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const Color _accentColor = Color(0xFFFC6060);
  static const Color _pageBackgroundColor = Colors.white;
  static const Color _dividerColor = Color(0xFFE5E5EA);
  static const Color _dialogBackgroundColor = Color(0xFFF2F2F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBackgroundColor,
      appBar: AppBar(
        backgroundColor: _pageBackgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: NotificationIconButton(),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/icons/team_manager.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'John@gmail.com',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF8E8E93),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const ProfileEditPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, thickness: 1, color: _dividerColor),
            _buildSettingsTile(
              icon: Icons.lock_outline,
              title: 'Change password',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const PrivacyPage()));
              },
            ),
            _buildSettingsTile(
              icon: Icons.description_outlined,
              title: 'Terms & Conditions',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const TermsAndConditionsPage(),
                  ),
                );
              },
            ),
            _buildSettingsTile(
              icon: Icons.logout,
              title: 'Logout',
              onTap: () async {
                final shouldLogout = await _showLogoutDialog(context);
                if (shouldLogout == true && context.mounted) {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/login', (route) => false);
                }
              },
            ),
            _buildSettingsTile(
              icon: Icons.delete_outline,
              title: 'Delete',
              isDestructive: true,
              onTap: () async {
                final shouldDelete = await _showDeleteDialog(context);
                if (shouldDelete == true && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deletion is not implemented yet.'),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: const Border(bottom: BorderSide(color: _dividerColor)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: _accentColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isDestructive ? _accentColor : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, size: 28, color: Color(0xFFC7C7CC)),
          ],
        ),
      ),
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 14),
          backgroundColor: _dialogBackgroundColor,
          surfaceTintColor: _dialogBackgroundColor,
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
                    onTap: () => Navigator.pop(ctx, false),
                    child: const Icon(
                      Icons.close,
                      size: 48,
                      color: Color(0xFF3C3C43),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SvgPicture.asset(
                  'assets/icons/logout.svg',
                  width: 112,
                  height: 112,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Logout?',
                  style: TextStyle(
                    fontSize: 48 / 3,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Do you really want to logout this account?',
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
                      backgroundColor: _accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40 / 3,
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

  Future<bool?> _showDeleteDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black38,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 14),
          backgroundColor: _dialogBackgroundColor,
          surfaceTintColor: _dialogBackgroundColor,
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
                    onTap: () => Navigator.pop(ctx, false),
                    child: const Icon(
                      Icons.close,
                      size: 48,
                      color: Color(0xFF3C3C43),
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                SvgPicture.asset(
                  'assets/icons/delete.svg',
                  width: 112,
                  height: 112,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Delete?',
                  style: TextStyle(
                    fontSize: 48 / 3,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Do you really want to Delete this account?',
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
                      backgroundColor: _accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40 / 3,
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
}
