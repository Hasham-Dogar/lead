import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/screens/signup/widgets/phone_input_field.dart';

class CreateContactPage extends StatefulWidget {
  final Contact? existingContact;

  const CreateContactPage({super.key, this.existingContact});

  @override
  State<CreateContactPage> createState() => _CreateContactPageState();
}

class _CreateContactPageState extends State<CreateContactPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _noteController;
  late Country _selectedCountry;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _noteController = TextEditingController();
    _selectedCountry = _buildDefaultCountry();

    if (widget.existingContact != null) {
      _firstNameController.text = widget.existingContact!.firstName;
      _lastNameController.text = widget.existingContact!.lastName;
      _phoneController.text = widget.existingContact!.phoneNumber;
      _emailController.text = widget.existingContact!.email;
      _noteController.text = widget.existingContact!.note;
      _selectedCountry = _buildDefaultCountry(
        phoneCode: widget.existingContact!.phoneCode,
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Country _buildDefaultCountry({String phoneCode = '1'}) {
    return Country(
      phoneCode: phoneCode,
      countryCode: 'US',
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: 'United States',
      example: '2012345678',
      displayName: 'United States (US) [+1]',
      displayNameNoCountryCode: 'United States (US)',
      e164Key: '',
    );
  }

  void _saveContact() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final note = _noteController.text.trim();

    if (firstName.isEmpty && phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Add a name or phone number to save'),
          backgroundColor: Color(0xFFFC6060),
        ),
      );
      return;
    }

    if (widget.existingContact != null) {
      final updated = widget.existingContact!.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNumber: phone,
        phoneCode: _selectedCountry.phoneCode,
        email: email,
        note: note,
      );
      Navigator.of(context).pop(updated);
      return;
    }

    final contact = Contact(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName,
      lastName: lastName,
      phoneNumber: phone,
      phoneCode: _selectedCountry.phoneCode,
      email: email,
      note: note,
    );

    Navigator.of(context).pop(contact);
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
        title: Text(
          widget.existingContact == null ? 'Create Contact' : 'Edit Contact',
          style: const TextStyle(
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
            // First Name
            const Text(
              'First Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                hintText: 'John',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 20,
                ),
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
            // Last Name
            const Text(
              'Last Name',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                hintText: 'Doe',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.person_outline,
                  color: Colors.grey,
                  size: 20,
                ),
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
            // Phone Number
            PhoneInputField(
              controller: _phoneController,
              initialCountry: _selectedCountry,
              onCountryChanged: (country) {
                setState(() {
                  _selectedCountry = country;
                });
              },
            ),
            const SizedBox(height: 20),
            // Email
            const Text(
              'Email',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'Enter email',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                prefixIcon: const Icon(
                  Icons.mail_outline,
                  color: Colors.grey,
                  size: 20,
                ),
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
            // Note
            const Text(
              'Note',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Write note...',
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
            const SizedBox(height: 32),
            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC6060),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  widget.existingContact == null ? 'Save' : 'Update',
                  style: const TextStyle(
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
}
