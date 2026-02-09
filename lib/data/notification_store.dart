import 'package:flutter/material.dart';
import 'package:leads/models/notification.dart';

class NotificationStore {
  static final NotificationStore instance = NotificationStore._internal();

  NotificationStore._internal() {
    // Add some sample notifications for demo purposes
    _addSampleNotifications();
  }

  final ValueNotifier<List<AppNotification>> notifications =
      ValueNotifier<List<AppNotification>>([]);

  void _addSampleNotifications() {
    // Add a few sample notifications so users can see the feature
    notifications.value = [
      AppNotification(
        id: '1',
        title: 'Welcome!',
        message:
            'Notifications will appear here when you create or update leads',
        type: NotificationType.newLead,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
      ),
    ];
  }

  int get unreadCount => notifications.value.where((n) => !n.isRead).length;

  void addNotification(AppNotification notification) {
    final updatedList = [notification, ...notifications.value];
    notifications.value = updatedList;
  }

  void markAsRead(String notificationId) {
    final updatedList = notifications.value.map((notification) {
      if (notification.id == notificationId) {
        return notification.copyWith(isRead: true);
      }
      return notification;
    }).toList();
    notifications.value = updatedList;
  }

  void markAllAsRead() {
    final updatedList = notifications.value
        .map((notification) => notification.copyWith(isRead: true))
        .toList();
    notifications.value = updatedList;
  }

  void deleteNotification(String notificationId) {
    final updatedList = notifications.value
        .where((notification) => notification.id != notificationId)
        .toList();
    notifications.value = updatedList;
  }

  void clearAll() {
    notifications.value = [];
  }

  // Helper methods to create notifications
  void notifyNewLead(String leadTitle, String leadId) {
    addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Lead Created',
        message: 'Lead "$leadTitle" has been created successfully',
        type: NotificationType.newLead,
        timestamp: DateTime.now(),
        leadId: leadId,
      ),
    );
  }

  void notifyLeadRescheduled(
    String leadTitle,
    String leadId,
    DateTime newDate,
  ) {
    final dateStr = '${newDate.day}/${newDate.month}/${newDate.year}';
    final timeStr =
        '${newDate.hour}:${newDate.minute.toString().padLeft(2, '0')}';
    addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Lead Rescheduled',
        message:
            'Lead "$leadTitle" has been rescheduled to $dateStr at $timeStr',
        type: NotificationType.leadRescheduled,
        timestamp: DateTime.now(),
        leadId: leadId,
      ),
    );
  }

  void notifyLeadCompleted(String leadTitle, String leadId) {
    addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Lead Completed',
        message: 'Lead "$leadTitle" has been marked as completed',
        type: NotificationType.leadCompleted,
        timestamp: DateTime.now(),
        leadId: leadId,
      ),
    );
  }

  void notifyLeadAssigned(
    String leadTitle,
    String leadId,
    String assigneeName,
  ) {
    addNotification(
      AppNotification(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Lead Assigned',
        message: 'Lead "$leadTitle" has been assigned to $assigneeName',
        type: NotificationType.leadAssigned,
        timestamp: DateTime.now(),
        leadId: leadId,
      ),
    );
  }
}
