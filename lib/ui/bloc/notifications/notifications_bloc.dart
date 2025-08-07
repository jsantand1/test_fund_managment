import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entites/notification/notification.dart';
import '../../../domain/entites/notification/notification_list.dart';
import '../../../ui/helpers/utils/utils.dart';
import 'notifications_event.dart';
import 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(const NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<AddNotification>(_onAddNotification);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<AddSubscriptionNotification>(_onAddSubscriptionNotification);
    on<AddUnsubscriptionNotification>(_onAddUnsubscriptionNotification);
  }

  void _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) {
    final currentState = state;
    
    // Si ya tenemos notificaciones cargadas, no las sobrescribimos
    if (currentState is NotificationsLoaded) {
      return;
    }
    
    emit(const NotificationsLoading());
    
    // Solo cargar lista vacía si no hay estado previo
    const notificationList = NotificationList(notifications: []);
    emit(NotificationsLoaded(notificationList));
  }

  void _onAddNotification(
    AddNotification event,
    Emitter<NotificationsState> emit,
  ) {
    final currentState = state;
    
    List<Notification> existingNotifications = [];
    if (currentState is NotificationsLoaded) {
      existingNotifications = currentState.notificationList.notifications;
    }
    
    final updatedNotifications = [
      event.notification,
      ...existingNotifications,
    ];
    
    final updatedList = NotificationList(notifications: updatedNotifications);
    emit(NotificationsLoaded(updatedList));
  }

  void _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updatedNotifications = currentState.notificationList.notifications
          .map((notification) {
        if (notification.id == event.notificationId) {
          return notification.copyWith(isRead: true);
        }
        return notification;
      }).toList();

      final updatedList = NotificationList(notifications: updatedNotifications);
      emit(NotificationsLoaded(updatedList));
    }
  }

  void _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationsState> emit,
  ) {
    final currentState = state;
    if (currentState is NotificationsLoaded) {
      final updatedNotifications = currentState.notificationList.notifications
          .map((notification) => notification.copyWith(isRead: true))
          .toList();

      final updatedList = NotificationList(notifications: updatedNotifications);
      emit(NotificationsLoaded(updatedList));
    }
  }

  void _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<NotificationsState> emit,
  ) {
    const notificationList = NotificationList(notifications: []);
    emit(const NotificationsLoaded(notificationList));
  }

  void _onAddSubscriptionNotification(
    AddSubscriptionNotification event,
    Emitter<NotificationsState> emit,
  ) {
    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Suscripción Exitosa',
      message: 'Te has suscrito al fondo "${event.fundName}" con un monto de ${UtilsApp.currencyFormat(event.amount, event.currency)}',
      type: NotificationType.subscription,
      createdAt: DateTime.now(),
      metadata: {
        'fundName': event.fundName,
        'amount': event.amount,
        'currency': event.currency,
        'action': 'subscription',
      },
    );

    _onAddNotification(AddNotification(notification), emit);
  }

  void _onAddUnsubscriptionNotification(
    AddUnsubscriptionNotification event,
    Emitter<NotificationsState> emit,
  ) {
    final notification = Notification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'Desuscripción Exitosa',
      message: 'Te has desuscrito del fondo "${event.fundName}" y has recuperado ${UtilsApp.currencyFormat(event.amount, event.currency)}',
      type: NotificationType.unsubscription,
      createdAt: DateTime.now(),
      metadata: {
        'fundName': event.fundName,
        'amount': event.amount,
        'currency': event.currency,
        'action': 'unsubscription',
      },
    );

    _onAddNotification(AddNotification(notification), emit);
  }
}
