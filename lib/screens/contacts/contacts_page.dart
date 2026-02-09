import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/widgets/notification_icon_button.dart';

class ContactsPage extends StatelessWidget {
  final List<Contact> contacts;
  final ValueChanged<Contact>? onContactTap;

  const ContactsPage({super.key, required this.contacts, this.onContactTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Contacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showSearch(
                            context: context,
                            delegate: _ContactsOnlySearchDelegate(
                              contacts: contacts,
                              onTap: (c) => onContactTap?.call(c),
                            ),
                          );
                        },
                        child: const Icon(Icons.search, color: Colors.black87),
                      ),
                      const SizedBox(width: 12),
                      const NotificationIconButton(),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: contacts.isEmpty
                  ? const _EmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return _ContactTile(
                          contact: contact,
                          onTap: () => onContactTap?.call(contact),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemCount: contacts.length,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/empty.png',
            width: 200,
            height: 200,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 12),
          const Text(
            'No Contact yet!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactsOnlySearchDelegate extends SearchDelegate<void> {
  final List<Contact> contacts;
  final void Function(Contact) onTap;
  _ContactsOnlySearchDelegate({required this.contacts, required this.onTap});

  @override
  String get searchFieldLabel => 'Search contacts';

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () => query = '',
          )
      ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(context, null),
      );

  @override
  Widget buildResults(BuildContext context) => _buildList();

  @override
  Widget buildSuggestions(BuildContext context) => _buildList();

  Widget _buildList() {
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? <Contact>[]
        : contacts.where((c) {
            final name = c.fullName.toLowerCase();
            final email = c.email.toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();

    if (q.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('Type to search contacts', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    if (filtered.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No contacts found', style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return ListView.builder(
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final c = filtered[index];
        return ListTile(
          leading: const Icon(Icons.person_outline, color: Color(0xFFFC6060)),
          title: Text(c.fullName, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(c.email.isNotEmpty ? c.email : c.phoneNumber),
          onTap: () => onTap(c),
        );
      },
    );
  }
}

class _ContactTile extends StatelessWidget {
  final Contact contact;
  final VoidCallback? onTap;

  const _ContactTile({required this.contact, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFC6060), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  contact.fullName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  _showNotePopover(context, details.globalPosition, contact);
                },
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: SvgPicture.asset(
                    'assets/icons/info.svg',
                    width: 25,
                    height: 25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNotePopover(
    BuildContext context,
    Offset tapPosition,
    Contact contact,
  ) {
    final noteText = contact.note.isNotEmpty ? contact.note : 'No note added';
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final size = overlay.size;

    const popWidth = 240.0;
    const popHeight = 110.0;
    double left = tapPosition.dx - popWidth + 12;
    double top = tapPosition.dy - (popHeight / 2);

    left = left.clamp(12.0, size.width - popWidth - 12);
    top = top.clamp(12.0, size.height - popHeight - 12);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Close',
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 120),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Stack(
          children: [
            Positioned(
              left: left,
              top: top,
              width: popWidth,
              child: Material(
                color: Colors.white,
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Note',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(Icons.close, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        noteText,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4F4F4F),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
