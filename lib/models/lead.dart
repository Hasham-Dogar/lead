class Lead {
  final String id;
  final String title;
  final String contactName;
  final String contactId;
  final String details;
  final DateTime dateTime;
  final LeadStatus status;

  const Lead({
    required this.id,
    required this.title,
    required this.contactName,
    required this.contactId,
    required this.details,
    required this.dateTime,
    required this.status,
  });

  Lead copyWith({
    String? id,
    String? title,
    String? contactName,
    String? contactId,
    String? details,
    DateTime? dateTime,
    LeadStatus? status,
  }) {
    return Lead(
      id: id ?? this.id,
      title: title ?? this.title,
      contactName: contactName ?? this.contactName,
      contactId: contactId ?? this.contactId,
      details: details ?? this.details,
      dateTime: dateTime ?? this.dateTime,
      status: status ?? this.status,
    );
  }
}

enum LeadStatus { pending, rescheduled, completed }

extension LeadStatusExtension on LeadStatus {
  String get displayName {
    switch (this) {
      case LeadStatus.pending:
        return 'Pending';
      case LeadStatus.rescheduled:
        return 'Rescheduled';
      case LeadStatus.completed:
        return 'Completed';
    }
  }
}
