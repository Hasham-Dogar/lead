import 'package:flutter/material.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/models/lead.dart';

class GlobalSearchDelegate extends SearchDelegate<void> {
  final List<Lead> leads;
  final List<Contact> contacts;
  final void Function(Lead) onLeadTap;
  final void Function(Contact) onContactTap;

  GlobalSearchDelegate({
    required this.leads,
    required this.contacts,
    required this.onLeadTap,
    required this.onContactTap,
  });

  @override
  ThemeData appBarTheme(BuildContext context) {
    final base = Theme.of(context);
    return base.copyWith(
      scaffoldBackgroundColor: Colors.white,
      canvasColor: Colors.white,
      cardColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        elevation: 0,
      ),
      inputDecorationTheme: base.inputDecorationTheme.copyWith(
        hintStyle:
            base.inputDecorationTheme.hintStyle?.copyWith(color: Colors.grey) ??
            const TextStyle(color: Colors.grey),
      ),
      textTheme: base.textTheme.apply(bodyColor: Colors.black),
    );
  }

  @override
  String get searchFieldLabel => 'Search leads or contacts';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(icon: const Icon(Icons.clear), onPressed: () => query = ''),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(color: Colors.white, child: _buildList(showEmpty: true));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(color: Colors.white, child: _buildList(showEmpty: false));
  }

  Widget _buildList({required bool showEmpty}) {
    final q = query.trim().toLowerCase();

    final filteredLeads = q.isEmpty
        ? <Lead>[]
        : leads.where((l) {
            final title = l.title.toLowerCase();
            final contact = l.contactName.toLowerCase();
            return title.contains(q) || contact.contains(q);
          }).toList();

    final filteredContacts = q.isEmpty
        ? <Contact>[]
        : contacts.where((c) {
            final name = c.fullName.toLowerCase();
            final email = c.email.toLowerCase();
            return name.contains(q) || email.contains(q);
          }).toList();

    if (!showEmpty && q.isEmpty) {
      return const _SearchHint();
    }

    if (filteredLeads.isEmpty && filteredContacts.isEmpty) {
      return const _EmptySearch();
    }

    return ListView(
      children: [
        if (filteredLeads.isNotEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Leads',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ...filteredLeads.map(
          (l) => ListTile(
            leading: const Icon(
              Icons.assignment_outlined,
              color: Color(0xFFFC6060),
            ),
            title: Text(
              l.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(l.contactName),
            onTap: () => onLeadTap(l),
          ),
        ),
        if (filteredContacts.isNotEmpty)
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Contacts',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ...filteredContacts.map(
          (c) => ListTile(
            leading: const Icon(Icons.person_outline, color: Color(0xFFFC6060)),
            title: Text(
              c.fullName,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(c.email.isNotEmpty ? c.email : c.phoneNumber),
            onTap: () => onContactTap(c),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SearchHint extends StatelessWidget {
  const _SearchHint();
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'Type to search leads or contacts',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch();
  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: Colors.white,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Text('No results found', style: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }
}
