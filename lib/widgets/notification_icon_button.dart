import 'package:flutter/material.dart';
import 'package:leads/data/notification_store.dart';
import 'package:leads/screens/notifications/notifications_page.dart';

class NotificationIconButton extends StatelessWidget {
  const NotificationIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: NotificationStore.instance.notifications.map(
        (notifications) => notifications.where((n) => !n.isRead).length,
      ),
      builder: (context, unreadCount, _) {
        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black87),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NotificationsPage()),
                );
              },
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFC6060),
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Center(
                    child: Text(
                      unreadCount > 9 ? '9+' : unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

// Extension to map ValueNotifier
extension ValueNotifierMap<T> on ValueNotifier<T> {
  ValueNotifier<R> map<R>(R Function(T) mapper) {
    final result = ValueNotifier<R>(mapper(value));
    addListener(() {
      result.value = mapper(value);
    });
    return result;
  }
}
