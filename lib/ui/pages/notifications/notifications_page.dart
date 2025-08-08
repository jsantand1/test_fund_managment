import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_fund_managment/domain/entites/notification/notification.dart' as domain;
import 'package:test_fund_managment/ui/bloc/notifications/notifications_bloc.dart';
import 'package:test_fund_managment/ui/bloc/notifications/notifications_event.dart';
import 'package:test_fund_managment/ui/bloc/notifications/notifications_state.dart';
import 'package:test_fund_managment/shared/components/components.dart';

class NotificationsPage extends StatefulWidget {
  static const String routeName = '/notifications';
  
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationsBloc>().add(const LoadNotifications());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<NotificationsBloc, NotificationsState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(state),
                const SizedBox(height: 16),
                Expanded(
                  child: _buildNotificationsList(state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(NotificationsState state) {
    final unreadCount = state is NotificationsLoaded ? state.notificationList.unreadCount : 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Notificaciones',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        if (unreadCount > 0) ...[
          const SizedBox(height: 4),
          Text(
            '$unreadCount sin leer',
            style: TextStyle(
              color: Colors.orange[600],
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all, size: 18),
              label: const Text('Marcar como leídas'),
            ),
            ElevatedButton.icon(
              onPressed: _clearAllNotifications,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Limpiar todo'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsList(NotificationsState state) {
    if (state is NotificationsLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is NotificationsError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red[300],
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar notificaciones',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(state.message),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<NotificationsBloc>().add(const LoadNotifications());
              },
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    if (state is NotificationsLoaded) {
      final notifications = state.notificationList.notifications;
      
      if (notifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No hay notificaciones',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Todas las notificaciones aparecerán aquí'),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return NotificationCard(
            notification: notification,
            onActionSelected: _handleNotificationAction,
          );
        },
      );
    }

    return const SizedBox.shrink();
  }



  void _handleNotificationAction(String action, domain.Notification notification) {
    switch (action) {
      case 'mark_read':
        context.read<NotificationsBloc>().add(MarkNotificationAsRead(notification.id));
        break;
      case 'delete':
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Funcionalidad no implementada aún')),
        );
        break;
    }
  }

  void _markAllAsRead() {
    context.read<NotificationsBloc>().add(const MarkAllNotificationsAsRead());
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Todas las notificaciones marcadas como leídas')),
    );
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Limpiar notificaciones'),
        content: const Text('¿Estás seguro de que deseas eliminar todas las notificaciones?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              context.read<NotificationsBloc>().add(const ClearAllNotifications());
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todas las notificaciones eliminadas')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar todas'),
          ),
        ],
      ),
    );
  }
}
