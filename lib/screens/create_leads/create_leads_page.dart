import 'package:flutter/material.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/data/lead_store.dart';
import 'package:leads/data/notification_store.dart';
import 'package:leads/screens/create_leads/contact_picker_page.dart';
import 'package:leads/screens/create_leads/custom_clock_picker.dart';
import 'package:leads/screens/create_leads/calendar_date_picker.dart'
    as leads_calendar;

class CreateLeadsPage extends StatefulWidget {
  final List<Contact>? contacts;

  const CreateLeadsPage({super.key, this.contacts});

  @override
  State<CreateLeadsPage> createState() => _CreateLeadsPageState();
}

class _CreateLeadsPageState extends State<CreateLeadsPage> {
  late TextEditingController _titleController;
  late TextEditingController _detailsController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  Contact? _selectedContact;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _detailsController = TextEditingController();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
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
          'Create Leads',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Leads Title
            const Text(
              'Leads Title',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Enter Lead Title',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                  vertical: 14,
                  horizontal: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Details
            const Text(
              'Details',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write details...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
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
                  vertical: 14,
                  horizontal: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Date & Time
            const Text(
              'Date & time',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select date',
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                    ),
                    onTap: () async {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => leads_calendar.CalendarDatePicker(
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 36500),
                            ),
                            onDateSelected: (DateTime selectedDate) {
                              setState(() {
                                _dateController.text =
                                    '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Enter time',
                      suffixIcon: const Icon(
                        Icons.access_time,
                        color: Colors.grey,
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 12,
                      ),
                    ),
                    onTap: () async {
                      showDialog<void>(
                        context: context,
                        builder: (_) => CustomClockPicker(
                          initialTime: TimeOfDay.now(),
                          onSave: (TimeOfDay time) {
                            setState(() {
                              _timeController.text =
                                  '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Add Contact
            const Text(
              'Add Contact',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedContact?.fullName ?? 'Select contact',
                    style: TextStyle(
                      fontSize: 14,
                      color: _selectedContact == null
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showContactPicker();
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFFFC6060),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_titleController.text.isEmpty ||
                      _selectedContact == null ||
                      _dateController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please fill all required fields'),
                        backgroundColor: Color(0xFFFC6060),
                      ),
                    );
                    return;
                  }

                  try {
                    // Create lead object
                    final dateTimeParts = _dateController.text.split('/');
                    final day = int.parse(dateTimeParts[0]);
                    final month = int.parse(dateTimeParts[1]);
                    final year = int.parse(dateTimeParts[2]);

                    int hour = 0;
                    int minute = 0;

                    if (_timeController.text.isNotEmpty) {
                      final timeParts = _timeController.text.split(':');
                      if (timeParts.length >= 2) {
                        hour = int.parse(timeParts[0]);
                        minute = int.parse(timeParts[1]);
                      }
                    }

                    final dateTime = DateTime(year, month, day, hour, minute);

                    final newLead = Lead(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: _titleController.text,
                      contactName: _selectedContact!.fullName,
                      contactId: _selectedContact!.id,
                      details: _detailsController.text,
                      dateTime: dateTime,
                      status: LeadStatus.pending,
                    );

                    // Persist in shared store so dashboards reflect the new lead.
                    LeadStore.instance.addLead(newLead);

                    // Create notification for new lead
                    NotificationStore.instance.notifyNewLead(
                      newLead.title,
                      newLead.id,
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lead saved successfully'),
                        backgroundColor: Color(0xFFFC6060),
                      ),
                    );
                    Navigator.of(context).pop(newLead);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error saving lead: $e'),
                        backgroundColor: Color(0xFFFC6060),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC6060),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactPicker() {
    final contacts = widget.contacts ?? [];

    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No contacts available'),
          backgroundColor: Color(0xFFFC6060),
        ),
      );
      return;
    }

    Navigator.of(context)
        .push<Contact>(
          MaterialPageRoute(
            builder: (context) => ContactPickerPage(
              contacts: contacts,
              selectedContact: _selectedContact,
            ),
          ),
        )
        .then((selected) {
          if (selected != null) {
            setState(() {
              _selectedContact = selected;
            });
          }
        });
  }
}
