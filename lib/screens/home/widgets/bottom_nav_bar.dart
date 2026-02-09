import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final String secondItemLabel;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.secondItemLabel = 'Contacts',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey.shade300, Colors.grey.shade200, Colors.white],
          stops: const [0.0, 0.02, 0.02],
        ),
      ),
      child: BottomAppBar(
        color: Colors.white,
        elevation: 0,
        child: SizedBox(
          height: 72,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _NavBarItem(
                  icon: 'assets/icons/Home.svg',
                  label: 'Home',
                  isSelected: selectedIndex == 0,
                  onTap: () => onTap(0),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  icon: 'assets/icons/contacts.svg',
                  label: secondItemLabel,
                  isSelected: selectedIndex == 1,
                  onTap: () => onTap(1),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  icon: 'assets/icons/leads.svg',
                  label: 'Leads',
                  isSelected: selectedIndex == 2,
                  onTap: () => onTap(2),
                ),
              ),
              Expanded(
                child: _NavBarItem(
                  icon: 'assets/icons/settings.svg',
                  label: 'Settings',
                  isSelected: selectedIndex == 3,
                  onTap: () => onTap(3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            icon,
            width: 24,
            height: 24,
            color: isSelected ? const Color(0xFFFC6060) : Colors.grey.shade400,
          ),
          if (isSelected) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFC6060),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
