import 'package:flutter/material.dart';

enum NotificationType { newLead, leadRescheduled, leadCompleted, leadAssigned }

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  final String? leadId;
  final String? contactId;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.leadId,
    this.contactId,
  });

  AppNotification copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
    String? leadId,
    String? contactId,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      leadId: leadId ?? this.leadId,
      contactId: contactId ?? this.contactId,
    );
  }

  IconData get icon {
    switch (type) {
      case NotificationType.newLead:
        return Icons.add_circle;
      case NotificationType.leadRescheduled:
        return Icons.schedule;
      case NotificationType.leadCompleted:
        return Icons.check_circle;
      case NotificationType.leadAssigned:
        return Icons.person_add;
    }
  }

  Color get iconColor {
    switch (type) {
      case NotificationType.newLead:
        return const Color(0xFFFC6060);
      case NotificationType.leadRescheduled:
        return const Color(0xFFFF9800);
      case NotificationType.leadCompleted:
        return const Color(0xFF4CAF50);
      case NotificationType.leadAssigned:
        return const Color(0xFF2196F3);
    }
  }
}
