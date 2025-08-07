import 'package:equatable/equatable.dart';
import '../../../domain/entites/notification/notification.dart';

abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

class AddNotification extends NotificationsEvent {
  final Notification notification;

  const AddNotification(this.notification);

  @override
  List<Object?> get props => [notification];
}

class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationsEvent {
  const MarkAllNotificationsAsRead();
}

class ClearAllNotifications extends NotificationsEvent {
  const ClearAllNotifications();
}

class AddSubscriptionNotification extends NotificationsEvent {
  final String fundName;
  final double amount;
  final String currency;

  const AddSubscriptionNotification({
    required this.fundName,
    required this.amount,
    required this.currency,
  });

  @override
  List<Object?> get props => [fundName, amount, currency];
}

class AddUnsubscriptionNotification extends NotificationsEvent {
  final String fundName;
  final double amount;
  final String currency;

  const AddUnsubscriptionNotification({
    required this.fundName,
    required this.amount,
    required this.currency,
  });

  @override
  List<Object?> get props => [fundName, amount, currency];
}
