import 'package:equatable/equatable.dart';
import 'notification.dart';

class NotificationList extends Equatable {
  final List<Notification> notifications;

  const NotificationList({
    required this.notifications,
  });

  NotificationList copyWith({
    List<Notification>? notifications,
  }) {
    return NotificationList(
      notifications: notifications ?? this.notifications,
    );
  }

  // Getters útiles
  int get totalCount => notifications.length;
  int get unreadCount => notifications.where((n) => !n.isRead).length;
  int get readCount => notifications.where((n) => n.isRead).length;
  
  List<Notification> get subscriptionNotifications => 
      notifications.where((n) => n.type == NotificationType.subscription).toList();
  
  List<Notification> get unsubscriptionNotifications => 
      notifications.where((n) => n.type == NotificationType.unsubscription).toList();
  
  List<Notification> get unreadNotifications => 
      notifications.where((n) => !n.isRead).toList();

  @override
  List<Object?> get props => [notifications];
}
