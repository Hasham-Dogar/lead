import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/screens/create_contact/create_contact_page.dart';

class ContactDetailPage extends StatefulWidget {
  final Contact contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  State<ContactDetailPage> createState() => _ContactDetailPageState();
}

class _ContactDetailPageState extends State<ContactDetailPage> {
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _editContact() async {
    final updated = await Navigator.of(context).push<Contact>(
      MaterialPageRoute(
        builder: (context) => CreateContactPage(existingContact: _contact),
      ),
    );

    if (updated != null && mounted) {
      setState(() {
        _contact = updated;
      });
      Navigator.of(context).pop(updated);
    }
  }

  Future<void> _makePhoneCall() async {
    final phoneNumber = _contact.phoneCode + _contact.phoneNumber;
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      await launchUrl(uri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not launch phone call: $e')),
        );
      }
    }
  }

  Future<void> _openWhatsApp() async {
    final phoneNumber = _contact.phoneCode + _contact.phoneNumber;
    final uri = Uri.parse('https://wa.me/$phoneNumber');
    try {
      await launchUrl(uri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open WhatsApp: $e')));
      }
    }
  }

  Future<void> _sendEmail() async {
    if (_contact.email.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No email address available')),
        );
      }
      return;
    }
    final uri = Uri(scheme: 'mailto', path: _contact.email);
    try {
      await launchUrl(uri);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open email: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(_contact),
        ),
        title: const Text(
          'Contact details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _editContact,
            icon: const Icon(Icons.edit, color: Color.fromARGB(255, 0, 0, 0)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _contact.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _contact.formattedPhone,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF9E9E9E),
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 8,
                  children: [
                    GestureDetector(
                      onTap: _makePhoneCall,
                      child: _RoundIcon(icon: Icons.call, size: 22),
                    ),
                    GestureDetector(
                      onTap: _openWhatsApp,
                      child: _RoundSvgIcon(
                        svgPath: 'assets/icons/whatsapp.svg',
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            _Section(
              title: 'Email',
              value: _contact.email.isNotEmpty ? _contact.email : 'No email',
              trailing: GestureDetector(
                onTap: _sendEmail,
                child: _RoundIcon(icon: Icons.mail, size: 24),
              ),
            ),
            const SizedBox(height: 20),
            _Section(
              title: 'Note',
              value: _contact.note.isNotEmpty ? _contact.note : 'No note added',
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String value;
  final Widget? trailing;

  const _Section({required this.title, required this.value, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(fontSize: 13, color: Color(0xFF757575)),
              ),
            ],
          ),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ],
    );
  }
}

class _RoundIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const _RoundIcon({required this.icon, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 245, 245),
        border: Border.all(color: const Color(0xFFFC6060), width: 2),
      ),
      child: Icon(icon, color: const Color(0xFFFC6060), size: size),
    );
  }
}

class _RoundSvgIcon extends StatelessWidget {
  final String svgPath;
  final double size;

  const _RoundSvgIcon({required this.svgPath, this.size = 20});

  @override
  Widget build(BuildContext context) {
    const whatsappSvg =
        '''<svg width="18" height="18" viewBox="-1 -2 20 24" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.06753 1.51221C13.2405 1.51221 16.6231 4.89483 16.6231 9.06776C16.6231 13.2407 13.2405 16.6233 9.06753 16.6233C7.73228 16.6256 6.4205 16.2722 5.26709 15.5995L1.515 16.6233L2.53651 12.8697C1.86328 11.7159 1.50963 10.4036 1.51197 9.06776C1.51197 4.89483 4.8946 1.51221 9.06753 1.51221ZM6.4926 5.51665L6.34149 5.5227C6.24379 5.52943 6.14833 5.55509 6.06042 5.59825C5.9785 5.64473 5.90369 5.70274 5.83829 5.77052C5.74762 5.8559 5.69624 5.92994 5.64109 6.00172C5.36162 6.36507 5.21115 6.81115 5.21344 7.26954C5.21495 7.63976 5.31166 8.00016 5.46277 8.33714C5.7718 9.01865 6.28029 9.74021 6.95122 10.4089C7.11291 10.5698 7.27157 10.7315 7.44233 10.8819C8.27603 11.6158 9.26948 12.1451 10.3437 12.4277L10.7728 12.4935C10.9126 12.501 11.0524 12.4904 11.1929 12.4836C11.4129 12.472 11.6277 12.4125 11.8223 12.3091C11.9211 12.258 12.0177 12.2025 12.1117 12.1429C12.1117 12.1429 12.1437 12.1212 12.2061 12.0749C12.3081 11.9993 12.3708 11.9457 12.4554 11.8573C12.5189 11.7918 12.5718 11.7157 12.6141 11.6291C12.673 11.5059 12.732 11.271 12.7562 11.0753C12.7743 10.9257 12.769 10.8441 12.7667 10.7935C12.7637 10.7126 12.6965 10.6287 12.6232 10.5932L12.1834 10.396C12.1834 10.396 11.5261 10.1097 11.1242 9.92683C11.0821 9.90851 11.037 9.89802 10.9912 9.89585C10.9395 9.89044 10.8872 9.89621 10.8379 9.91277C10.7887 9.92932 10.7435 9.95628 10.7056 9.99181C10.7018 9.9903 10.6512 10.0334 10.1049 10.6952C10.0736 10.7374 10.0304 10.7692 9.98085 10.7867C9.93133 10.8042 9.87772 10.8065 9.82686 10.7935C9.77762 10.7803 9.72939 10.7637 9.68255 10.7436C9.58886 10.7043 9.55637 10.6892 9.49215 10.662C9.05837 10.473 8.65684 10.2173 8.30215 9.90416C8.20695 9.82105 8.11855 9.73038 8.02789 9.64274C7.73066 9.35805 7.47161 9.03602 7.25722 8.6847L7.21264 8.61292C7.18111 8.56441 7.15525 8.51244 7.13557 8.45803C7.10686 8.34696 7.18166 8.25781 7.18166 8.25781C7.18166 8.25781 7.36526 8.05683 7.45064 7.94803C7.53375 7.84225 7.60402 7.7395 7.64935 7.66621C7.73851 7.52265 7.76646 7.37532 7.71962 7.26123C7.50806 6.74443 7.28946 6.2304 7.0638 5.71914C7.01922 5.6179 6.887 5.54536 6.76686 5.53101C6.72606 5.52597 6.68526 5.52194 6.64446 5.51892C6.54301 5.5131 6.44129 5.51411 6.33997 5.52194L6.4926 5.51665Z" fill="#FC6060"/>
</svg>''';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 245, 245),
        border: Border.all(color: const Color(0xFFFC6060), width: 2),
      ),
      child: ClipOval(
        child: SvgPicture.string(
          whatsappSvg,
          width: size,
          height: size,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(
            Color(0xFFFC6060),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
