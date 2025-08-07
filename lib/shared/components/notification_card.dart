import 'package:flutter/material.dart';
import 'package:test_fund_managment/ui/helpers/utils/responsive.dart';
import '../../ui/models/notification_item.dart';
import '../../ui/helpers/enums/enums.dart';
class NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final Function(String, NotificationItem) onActionSelected;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onActionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileCard(context),
      tablet: _buildDesktopCard(context),
      desktop: _buildDesktopCard(context),
    );
  }

  Widget _buildMobileCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: Responsive.value(
          context,
          mobile: 8,
          tablet: 12,
          desktop: 12,
        ),
      ),
      elevation: notification.isRead ? 1 : 3,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    _getNotificationIcon(notification.type),
                    color: _getNotificationColor(notification.type),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead)
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _formatTimestamp(notification.timestamp),
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: _getNotificationColor(notification.type).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _getNotificationTypeLabel(notification.type),
                              style: TextStyle(
                                fontSize: 8,
                                color: _getNotificationColor(notification.type),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) => onActionSelected(value, notification),
                  icon: const Icon(Icons.more_vert, size: 20),
                  itemBuilder: (context) => [
                    if (!notification.isRead)
                      const PopupMenuItem(
                        value: 'mark_read',
                        child: Row(
                          children: [
                            Icon(Icons.mark_email_read, size: 18),
                            SizedBox(width: 8),
                            Text('Marcar como leída', style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Eliminar', style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              notification.message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopCard(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(
        bottom: Responsive.value(
          context,
          mobile: 12,
          tablet: 12,
          desktop: 16,
          largeDesktop: 20,
        ),
      ),
      elevation: notification.isRead ? 1 : 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(
          Responsive.value(
            context,
            mobile: 16,
            tablet: 16,
            desktop: 20,
            largeDesktop: 24,
          ),
        ),
        leading: Container(
          width: Responsive.value(
            context,
            mobile: 44,
            tablet: 44,
            desktop: 48,
            largeDesktop: 52,
          ),
          height: Responsive.value(
            context,
            mobile: 44,
            tablet: 44,
            desktop: 48,
            largeDesktop: 52,
          ),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(
              Responsive.value(
                context,
                mobile: 22,
                tablet: 22,
                desktop: 24,
                largeDesktop: 26,
              ),
            ),
          ),
          child: Icon(
            _getNotificationIcon(notification.type),
            color: _getNotificationColor(notification.type),
            size: Responsive.value(
              context,
              mobile: 20,
              tablet: 20,
              desktop: 24,
              largeDesktop: 26,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
                  fontSize: Responsive.value(
                    context,
                    mobile: 14,
                    tablet: 14,
                    desktop: 16,
                    largeDesktop: 18,
                  ),
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Responsive.value(
              context,
              mobile: 6,
              tablet: 6,
              desktop: 8,
              largeDesktop: 10,
            )),
            Text(
              notification.message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: Responsive.value(
                  context,
                  mobile: 12,
                  tablet: 12,
                  desktop: 14,
                  largeDesktop: 16,
                ),
              ),
            ),
            SizedBox(height: Responsive.value(
              context,
              mobile: 6,
              tablet: 6,
              desktop: 8,
              largeDesktop: 10,
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _formatTimestamp(notification.timestamp),
                    style: TextStyle(
                      fontSize: Responsive.value(
                        context,
                        mobile: 11,
                        tablet: 11,
                        desktop: 12,
                        largeDesktop: 13,
                      ),
                      color: Colors.grey[500],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Responsive.value(
                      context,
                      mobile: 6,
                      tablet: 6,
                      desktop: 8,
                      largeDesktop: 10,
                    ),
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(notification.type).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _getNotificationTypeLabel(notification.type),
                    style: TextStyle(
                      fontSize: Responsive.value(
                        context,
                        mobile: 9,
                        tablet: 9,
                        desktop: 10,
                        largeDesktop: 11,
                      ),
                      color: _getNotificationColor(notification.type),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) => onActionSelected(value, notification),
          itemBuilder: (context) => [
            if (!notification.isRead)
              const PopupMenuItem(
                value: 'mark_read',
                child: ListTile(
                  leading: Icon(Icons.mark_email_read),
                  title: Text('Marcar como leída'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            const PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Eliminar', style: TextStyle(color: Colors.red)),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.investment:
        return Colors.green;
      case NotificationType.alert:
        return Colors.red;
      case NotificationType.report:
        return Colors.blue;
      case NotificationType.user:
        return Colors.purple;
      case NotificationType.system:
        return Colors.orange;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.investment:
        return Icons.trending_up;
      case NotificationType.alert:
        return Icons.warning;
      case NotificationType.report:
        return Icons.assessment;
      case NotificationType.user:
        return Icons.person_add;
      case NotificationType.system:
        return Icons.settings;
    }
  }

  String _getNotificationTypeLabel(NotificationType type) {
    switch (type) {
      case NotificationType.investment:
        return 'INVERSIÓN';
      case NotificationType.alert:
        return 'ALERTA';
      case NotificationType.report:
        return 'REPORTE';
      case NotificationType.user:
        return 'USUARIO';
      case NotificationType.system:
        return 'SISTEMA';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return 'Hace ${difference.inMinutes} minutos';
    } else if (difference.inHours < 24) {
      return 'Hace ${difference.inHours} horas';
    } else {
      return 'Hace ${difference.inDays} días';
    }
  }
}
