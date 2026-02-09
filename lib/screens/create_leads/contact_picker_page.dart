import 'package:flutter/material.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/screens/create_contact/create_contact_page.dart';

class ContactPickerPage extends StatefulWidget {
  final List<Contact> contacts;
  final Contact? selectedContact;

  const ContactPickerPage({
    super.key,
    required this.contacts,
    this.selectedContact,
  });

  @override
  State<ContactPickerPage> createState() => _ContactPickerPageState();
}

class _ContactPickerPageState extends State<ContactPickerPage> {
  late TextEditingController _searchController;
  late List<Contact> _filteredContacts;
  late Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredContacts = widget.contacts;
    _selectedContact = widget.selectedContact;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openCreateContact() async {
    final newContact = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(builder: (context) => const CreateContactPage()),
    );

    if (newContact != null) {
      setState(() {
        _filteredContacts = [...widget.contacts, newContact];
        _selectedContact = newContact;
      });
    }
  }

  void _filterContacts(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredContacts = widget.contacts;
      } else {
        _filteredContacts = widget.contacts
            .where(
              (contact) =>
                  contact.fullName.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Contacts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_selectedContact != null)
            TextButton(
              onPressed: () => Navigator.of(context).pop(_selectedContact),
              child: const Text(
                'Done',
                style: TextStyle(
                  color: Color(0xFFFC6060),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search field
            TextField(
              controller: _searchController,
              onChanged: _filterContacts,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.grey, width: 1),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 12,
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Contacts list
            Expanded(
              child: ListView.separated(
                itemCount: _filteredContacts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final contact = _filteredContacts[index];
                  final isSelected = _selectedContact?.id == contact.id;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedContact = contact;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFC6060)
                              : Colors.grey.shade300,
                          width: 1.5,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            contact.fullName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                _selectedContact = value == true
                                    ? contact
                                    : null;
                              });
                            },
                            activeColor: const Color(0xFFFC6060),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateContact,
        backgroundColor: const Color(0xFFFC6060),
        shape: const CircleBorder(),
        heroTag: 'contactPickerFab',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
