import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:leads/models/lead.dart';
import 'package:leads/models/contact.dart';
import 'package:leads/data/notification_store.dart';

class LeadDetailPage extends StatefulWidget {
  final Lead lead;
  final Contact? contact;
  final Function(Lead) onLeadUpdate;
  final List<Contact>? assignableContacts;
  final bool isManager;

  const LeadDetailPage({
    super.key,
    required this.lead,
    this.contact,
    required this.onLeadUpdate,
    this.assignableContacts,
    this.isManager = false,
  });

  @override
  State<LeadDetailPage> createState() => _LeadDetailPageState();
}

class _LeadDetailPageState extends State<LeadDetailPage> {
  late Lead _lead;

  @override
  void initState() {
    super.initState();
    _lead = widget.lead;
  }

  Future<void> _makePhoneCall() async {
    if (widget.contact == null) return;
    final phoneNumber = widget.contact!.phoneCode + widget.contact!.phoneNumber;
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
    if (widget.contact == null) return;
    final phoneNumber = widget.contact!.phoneCode + widget.contact!.phoneNumber;
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
    if (widget.contact == null || widget.contact!.email.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No email address available')),
        );
      }
      return;
    }
    final uri = Uri(scheme: 'mailto', path: widget.contact!.email);
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

  void _markAsComplete() {
    final updatedLead = _lead.copyWith(status: LeadStatus.completed);
    setState(() {
      _lead = updatedLead;
    });
    widget.onLeadUpdate(updatedLead);

    // Create notification for completed lead
    NotificationStore.instance.notifyLeadCompleted(
      updatedLead.title,
      updatedLead.id,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Lead marked as completed'),
        backgroundColor: Color(0xFFFC6060),
      ),
    );
  }

  void _reschedule() {
    _showRescheduleDialog();
  }

  void _assignTo() {
    final contacts = (widget.assignableContacts ?? [])
        .where((c) => c.id != _lead.contactId)
        .toList();

    if (contacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No other contacts to assign.')),
      );
      return;
    }

    showModalBottomSheet<Contact>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        Contact? selected;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Assign Leads',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: contacts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        final isSelected = selected?.id == contact.id;
                        return InkWell(
                          onTap: () => setModalState(() => selected = contact),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFFC6060)
                                    : Colors.grey.shade300,
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  contact.fullName,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                                Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                      color: isSelected
                                          ? const Color(0xFFFC6060)
                                          : Colors.grey.shade400,
                                      width: 1.2,
                                    ),
                                    color: isSelected
                                        ? const Color(0xFFFFF0F0)
                                        : Colors.white,
                                  ),
                                  child: isSelected
                                      ? const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: Color(0xFFFC6060),
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: selected == null
                          ? null
                          : () {
                              final updatedLead = _lead.copyWith(
                                contactId: selected!.id,
                                contactName: selected!.fullName,
                              );
                              setState(() {
                                _lead = updatedLead;
                              });
                              widget.onLeadUpdate(updatedLead);

                              // Create notification for lead assignment
                              NotificationStore.instance.notifyLeadAssigned(
                                updatedLead.title,
                                updatedLead.id,
                                selected!.fullName,
                              );

                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Assigned to ${selected!.fullName}',
                                  ),
                                  backgroundColor: const Color(0xFFFC6060),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFC6060),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Assign',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRescheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => _RescheduleDialog(
        currentDateTime: _lead.dateTime,
        onReschedule: (newDateTime) {
          final updatedLead = _lead.copyWith(
            dateTime: newDateTime,
            status: LeadStatus.rescheduled,
          );
          setState(() {
            _lead = updatedLead;
          });
          widget.onLeadUpdate(updatedLead);

          // Create notification for rescheduled lead
          NotificationStore.instance.notifyLeadRescheduled(
            updatedLead.title,
            updatedLead.id,
            newDateTime,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Lead rescheduled'),
              backgroundColor: Color(0xFFFC6060),
            ),
          );
          Navigator.of(context).pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isCompleted = _lead.status == LeadStatus.completed;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(_lead),
        ),
        title: const Text(
          'Lead details',
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (!isCompleted)
            TextButton(
              onPressed: () {
                // TODO: Implement edit functionality
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Color(0xFFFC6060),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _lead.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: _lead.status == LeadStatus.completed
                        ? const Color(0xFFDDFFF1)
                        : _lead.status == LeadStatus.rescheduled
                        ? const Color(0xFFFFFCEA)
                        : const Color.fromARGB(255, 245, 245, 245),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    _lead.status.displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _lead.status == LeadStatus.completed
                          ? const Color(0xFF4CAF50)
                          : _lead.status == LeadStatus.rescheduled
                          ? const Color(0xFFF57C00)
                          : const Color(0xFF999999),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Date and time
            _SectionHeader(title: 'Date and time'),
            const SizedBox(height: 8),
            Text(
              '${_lead.dateTime.day} ${_getMonthName(_lead.dateTime.month)}, ${_lead.dateTime.year} | ${_lead.dateTime.hour.toString().padLeft(2, '0')}:${_lead.dateTime.minute.toString().padLeft(2, '0')} ${_lead.dateTime.hour >= 12 ? 'PM' : 'AM'}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 24),
            // Details
            _SectionHeader(title: 'Details'),
            const SizedBox(height: 8),
            Text(
              _lead.details,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF757575),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Contact
            _SectionHeader(title: 'Contact'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 245, 245),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFFFC6060),
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.person, size: 16, color: Colors.black),
                      const SizedBox(width: 8),
                      Text(
                        _lead.contactName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  spacing: 12,
                  children: [
                    if (widget.contact != null) ...[
                      GestureDetector(
                        onTap: _makePhoneCall,
                        child: _RoundActionIcon(icon: Icons.call, size: 18),
                      ),
                      GestureDetector(
                        onTap: _sendEmail,
                        child: _RoundActionIcon(icon: Icons.mail, size: 18),
                      ),
                      GestureDetector(
                        onTap: _openWhatsApp,
                        child: _RoundSvgIcon(
                          svgPath: 'assets/icons/whatsapp.svg',
                          size: 18,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const Spacer(),
            // Action buttons - show different buttons for managers vs members
            if (_lead.status != LeadStatus.completed) ...[
              if (widget.isManager &&
                  widget.assignableContacts != null &&
                  widget.assignableContacts!.isNotEmpty)
                // Manager view: Show only Assign To button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _assignTo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFC6060),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Assign To',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                )
              else
                // Member view: Show Mark Complete and Reschedule buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _markAsComplete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFC6060),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Mark as Complete',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _reschedule,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: const BorderSide(
                            color: Color(0xFFFC6060),
                            width: 1,
                          ),
                        ),
                        child: const Text(
                          'Reschedule',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFC6060),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[month - 1];
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }
}

class _RoundActionIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const _RoundActionIcon({required this.icon, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 245, 245),
        border: Border.all(color: const Color(0xFFFC6060), width: 1.5),
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
        '''<svg width="10" height="10" viewBox="0 0 19 19" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M9.06753 1.51221C13.2405 1.51221 16.6231 4.89483 16.6231 9.06776C16.6231 13.2407 13.2405 16.6233 9.06753 16.6233C7.73228 16.6256 6.4205 16.2722 5.26709 15.5995L1.515 16.6233L2.53651 12.8697C1.86328 11.7159 1.50963 10.4036 1.51197 9.06776C1.51197 4.89483 4.8946 1.51221 9.06753 1.51221ZM6.4926 5.51665L6.34149 5.5227C6.24379 5.52943 6.14833 5.55509 6.06042 5.59825C5.9785 5.64473 5.90369 5.70274 5.83829 5.77052C5.74762 5.8559 5.69624 5.92994 5.64109 6.00172C5.36162 6.36507 5.21115 6.81115 5.21344 7.26954C5.21495 7.63976 5.31166 8.00016 5.46277 8.33714C5.7718 9.01865 6.28029 9.74021 6.95122 10.4089C7.11291 10.5698 7.27157 10.7315 7.44233 10.8819C8.27603 11.6158 9.26948 12.1451 10.3437 12.4277L10.7728 12.4935C10.9126 12.501 11.0524 12.4904 11.1929 12.4836C11.4129 12.472 11.6277 12.4125 11.8223 12.3091C11.9211 12.258 12.0177 12.2025 12.1117 12.1429C12.1117 12.1429 12.1437 12.1212 12.2061 12.0749C12.3081 11.9993 12.3708 11.9457 12.4554 11.8573C12.5189 11.7918 12.5718 11.7157 12.6141 11.6291C12.673 11.5059 12.732 11.271 12.7562 11.0753C12.7743 10.9257 12.769 10.8441 12.7667 10.7935C12.7637 10.7126 12.6965 10.6287 12.6232 10.5932L12.1834 10.396C12.1834 10.396 11.5261 10.1097 11.1242 9.92683C11.0821 9.90851 11.037 9.89802 10.9912 9.89585C10.9395 9.89044 10.8872 9.89621 10.8379 9.91277C10.7887 9.92932 10.7435 9.95628 10.7056 9.99181C10.7018 9.9903 10.6512 10.0334 10.1049 10.6952C10.0736 10.7374 10.0304 10.7692 9.98085 10.7867C9.93133 10.8042 9.87772 10.8065 9.82686 10.7935C9.77762 10.7803 9.72939 10.7637 9.68255 10.7436C9.58886 10.7043 9.55637 10.6892 9.49215 10.662C9.05837 10.473 8.65684 10.2173 8.30215 9.90416C8.20695 9.82105 8.11855 9.73038 8.02789 9.64274C7.73066 9.35805 7.47161 9.03602 7.25722 8.6847L7.21264 8.61292C7.18111 8.56441 7.15525 8.51244 7.13557 8.45803C7.10686 8.34696 7.18166 8.25781 7.18166 8.25781C7.18166 8.25781 7.36526 8.05683 7.45064 7.94803C7.53375 7.84225 7.60402 7.7395 7.64935 7.66621C7.73851 7.52265 7.76646 7.37532 7.71962 7.26123C7.50806 6.74443 7.28946 6.2304 7.0638 5.71914C7.01922 5.6179 6.887 5.54536 6.76686 5.53101C6.72606 5.52597 6.68526 5.52194 6.64446 5.51892C6.54301 5.5131 6.44129 5.51411 6.33997 5.52194L6.4926 5.51665Z" fill="#FC6060"/>
</svg>''';

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 245, 245),
        border: Border.all(color: const Color(0xFFFC6060), width: 1.5),
      ),
      child: Center(
        child: SvgPicture.string(
          whatsappSvg,
          width: size * 1.5,
          height: size * 1.5,
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

class _RescheduleDialog extends StatefulWidget {
  final DateTime currentDateTime;
  final Function(DateTime) onReschedule;

  const _RescheduleDialog({
    required this.currentDateTime,
    required this.onReschedule,
  });

  @override
  State<_RescheduleDialog> createState() => _RescheduleDialogState();
}

class _RescheduleDialogState extends State<_RescheduleDialog> {
  late DateTime _selectedDateTime;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = widget.currentDateTime;
    _dateController = TextEditingController(
      text:
          '${widget.currentDateTime.day}/${widget.currentDateTime.month}/${widget.currentDateTime.year}',
    );
    _timeController = TextEditingController(
      text:
          '${widget.currentDateTime.hour.toString().padLeft(2, '0')}:${widget.currentDateTime.minute.toString().padLeft(2, '0')}',
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Reschedule Lead',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.of(context).pop(),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a new date and time for this lead.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Color(0xFF666666),
              ),
            ),
            const SizedBox(height: 20),
            // Date & time label
            const Text(
              'Date & time',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            // Date and time inputs side by side
            Row(
              spacing: 12,
              children: [
                // Date input
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Select date',
                      hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Color(0xFFBDBDBD),
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: _selectedDateTime,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            _selectedDateTime.hour,
                            _selectedDateTime.minute,
                          );
                          _dateController.text =
                              '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
                        });
                      }
                    },
                  ),
                ),
                // Time input
                Expanded(
                  child: TextField(
                    controller: _timeController,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Enter time',
                      hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
                      prefixIcon: const Icon(
                        Icons.access_time,
                        color: Color(0xFFBDBDBD),
                        size: 18,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Color(0xFFE0E0E0),
                          width: 1,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                    ),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          _selectedDateTime = DateTime(
                            _selectedDateTime.year,
                            _selectedDateTime.month,
                            _selectedDateTime.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          _timeController.text =
                              '${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')}';
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Update button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onReschedule(_selectedDateTime);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFC6060),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Update',
                  style: TextStyle(
                    fontSize: 14,
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
