import 'package:flutter/material.dart';
import 'package:leads/models/contact.dart';

class AddTeamMemberPage extends StatefulWidget {
  final List<Contact> contacts;
  final List<Contact> existingMembers;

  const AddTeamMemberPage({
    super.key,
    required this.contacts,
    required this.existingMembers,
  });

  @override
  State<AddTeamMemberPage> createState() => _AddTeamMemberPageState();
}

class _AddTeamMemberPageState extends State<AddTeamMemberPage> {
  final TextEditingController _searchController = TextEditingController();
  final Set<String> _selectedIds = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Contact> get _results {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return [];
    }
    final existingIds = widget.existingMembers.map((c) => c.id).toSet();
    return widget.contacts
        .where((c) => !existingIds.contains(c.id))
        .where((c) => c.email.toLowerCase().contains(query))
        .toList();
  }

  void _addSelected() {
    if (_selectedIds.isNotEmpty) {
      final selected = widget.contacts
          .where((c) => _selectedIds.contains(c.id))
          .toList(growable: false);
      Navigator.of(context).pop(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Add Members',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: "Search via user's registered email.",
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF999999),
                ),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF999999)),
                filled: true,
                fillColor: const Color(0xFFF7F7F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
            ),
          ),
          Expanded(
            child: results.isEmpty
                ? Center(
                    child: Text(
                      _searchController.text.isEmpty
                          ? 'Type an email to search'
                          : 'No results found',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      final contact = results[index];
                      final isSelected = _selectedIds.contains(contact.id);
                      return ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        leading: CircleAvatar(
                          radius: 22,
                          backgroundColor: const Color(0xFFFFEAEA),
                          backgroundImage: const AssetImage(
                            'assets/icons/member.png',
                          ),
                          child: const SizedBox.shrink(),
                        ),
                        title: Text(
                          contact.fullName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          contact.email,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF777777),
                          ),
                        ),
                        trailing: Checkbox(
                          value: isSelected,
                          activeColor: const Color(0xFFFC6060),
                          onChanged: (_) {
                            setState(() {
                              if (isSelected) {
                                _selectedIds.remove(contact.id);
                              } else {
                                _selectedIds.add(contact.id);
                              }
                            });
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIds.remove(contact.id);
                            } else {
                              _selectedIds.add(contact.id);
                            }
                          });
                        },
                      );
                    },
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemCount: results.length,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIds.isEmpty ? null : _addSelected,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedIds.isEmpty
                      ? const Color(0xFFBDBDBD)
                      : const Color(0xFFFC6060),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Add Contact',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
