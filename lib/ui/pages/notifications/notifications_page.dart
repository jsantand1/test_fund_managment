import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:test_fund_managment/domain/entites/notification/notification.dart' as domain;
import 'package:test_fund_managment/ui/bloc/notifications/notifications_bloc.dart';
import 'package:test_fund_managment/ui/bloc/notifications/notifications_event.dart';
import 'package:test_fund_managment/ui/bloc/notifications/notifications_state.dart';

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
          return _buildNotificationCard(notification);
        },
      );
    }

    return const SizedBox.shrink();
  }

  Widget _buildNotificationCard(domain.Notification notification) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getNotificationColor(notification.type),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 4),
            Text(
              _formatDateTime(notification.createdAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (action) => _handleNotificationAction(action, notification),
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: Row(
                  children: [
                    Icon(Icons.mark_email_read, size: 16),
                    SizedBox(width: 8),
                    Text('Marcar como leída'),
                  ],
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 16, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Eliminar', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
        ),
        isThreeLine: true,
        tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
      ),
    );
  }

  Color _getNotificationColor(domain.NotificationType type) {
    switch (type) {
      case domain.NotificationType.subscription:
        return Colors.green;
      case domain.NotificationType.unsubscription:
        return Colors.orange;
      case domain.NotificationType.general:
        return Colors.blue;
    }
  }

  IconData _getNotificationIcon(domain.NotificationType type) {
    switch (type) {
      case domain.NotificationType.subscription:
        return Icons.trending_up;
      case domain.NotificationType.unsubscription:
        return Icons.trending_down;
      case domain.NotificationType.general:
        return Icons.info;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Hace un momento';
    } else if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(dateTime);
    }
  }

  void _handleNotificationAction(String action, domain.Notification notification) {
    switch (action) {
      case 'mark_read':
        context.read<NotificationsBloc>().add(MarkNotificationAsRead(notification.id));
        break;
      case 'delete':
        // Por ahora, no implementamos delete individual
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
