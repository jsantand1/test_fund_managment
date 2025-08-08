import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_fund_managment/domain/entites/notification/notification.dart' as domain;

/// Widget reutilizable para mostrar una notificación en formato de card
class NotificationCard extends StatelessWidget {
  final domain.Notification notification;
  final void Function(String action, domain.Notification notification)? onActionSelected;

  const NotificationCard({
    super.key,
    required this.notification,
    this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
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
        trailing: onActionSelected != null
            ? PopupMenuButton<String>(
                onSelected: (action) => onActionSelected!(action, notification),
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
              )
            : null,
        isThreeLine: true,
        tileColor: notification.isRead ? null : Colors.blue.withOpacity(0.05),
      ),
    );
  }

  /// Obtiene el color del avatar según el tipo de notificación
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

  /// Obtiene el icono del avatar según el tipo de notificación
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

  /// Formatea la fecha/hora de la notificación de forma relativa
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
}
