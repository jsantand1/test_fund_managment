import 'package:flutter/material.dart';
import 'package:test_fund_managment/ui/helpers/enums/enums.dart';
import 'package:test_fund_managment/ui/models/notification_item.dart';
import '../../../shared/components/notification_card.dart';
import '../../helpers/utils/responsive.dart';

class NotificationsPage extends StatefulWidget {
  static const String routeName = '/notifications';
  
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: '1',
      title: 'Nueva inversión registrada',
      message: 'Se ha registrado una nueva inversión en el Fondo de Tecnología por \$50,000',
      type: NotificationType.investment,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: false,
    ),
    NotificationItem(
      id: '2',
      title: 'Rendimiento mensual disponible',
      message: 'El reporte de rendimiento del mes de julio ya está disponible',
      type: NotificationType.report,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      isRead: false,
    ),
    NotificationItem(
      id: '3',
      title: 'Nuevo usuario registrado',
      message: 'María García se ha registrado como nueva inversora',
      type: NotificationType.user,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
      isRead: true,
    ),
    NotificationItem(
      id: '4',
      title: 'Alerta de rendimiento',
      message: 'El Fondo de Bonos ha tenido un rendimiento inferior al esperado',
      type: NotificationType.alert,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
    ),
    NotificationItem(
      id: '5',
      title: 'Mantenimiento programado',
      message: 'El sistema estará en mantenimiento el próximo domingo de 2:00 AM a 6:00 AM',
      type: NotificationType.system,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      isRead: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      body: ResponsivePadding(
        mobile: const EdgeInsets.all(16),
        tablet: const EdgeInsets.all(20),
        desktop: const EdgeInsets.all(24),
        largeDesktop: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(unreadCount),
            SizedBox(height: Responsive.value(
              context,
              mobile: 16,
              tablet: 20,
              desktop: 24,
              largeDesktop: 32,
            )),
            Expanded(
              child: _buildNotificationsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(int unreadCount) {
    return ResponsiveBuilder(
      mobile: _buildMobileHeader(unreadCount),
      tablet: _buildDesktopHeader(unreadCount),
      desktop: _buildDesktopHeader(unreadCount),
    );
  }

  Widget _buildMobileHeader(int unreadCount) {
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
              label: const Text('Marcar leídas', style: TextStyle(fontSize: 12)),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _clearAllNotifications,
              icon: const Icon(Icons.clear_all, size: 18),
              label: const Text('Limpiar', style: TextStyle(fontSize: 12)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDesktopHeader(int unreadCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Notificaciones',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (unreadCount > 0)
                Text(
                  '$unreadCount notificaciones sin leer',
                  style: TextStyle(
                    color: Colors.orange[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ),
        Wrap(
          spacing: 8,
          children: [
            TextButton.icon(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all),
              label: const Text('Marcar todas como leídas'),
            ),
            ElevatedButton.icon(
              onPressed: _clearAllNotifications,
              icon: const Icon(Icons.clear_all),
              label: const Text('Limpiar todo'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    if (_notifications.isEmpty) {
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
      itemCount: _notifications.length,
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return NotificationCard(
          notification: notification,
          onActionSelected: _handleNotificationAction,
        );
      },
    );
  }



  void _handleNotificationAction(String action, NotificationItem notification) {
    switch (action) {
      case 'mark_read':
        setState(() {
          notification.isRead = true;
        });
        break;
      case 'delete':
        setState(() {
          _notifications.remove(notification);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notificación eliminada')),
        );
        break;
    }
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification.isRead = true;
      }
    });
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
              setState(() {
                _notifications.clear();
              });
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
