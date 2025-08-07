import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:test_fund_managment/ui/models/navigation_item.dart';
import '../../ui/pages/funds/funds_page.dart';
import '../../ui/pages/notifications/notifications_page.dart';

class SidebarMenu extends StatefulWidget {
  final String currentRoute;
  final Function(String) onRouteChanged;
  final bool isMobile;
  final bool isTablet;

  const SidebarMenu({
    super.key,
    required this.currentRoute,
    required this.onRouteChanged,
    this.isMobile = false,
    this.isTablet = false,
  });

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  bool _isExpanded = true;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.account_balance,
      label: 'Fondos',
      route: FundsPage.routeName,
    ),
    NavigationItem(
      icon: Icons.notifications,
      label: 'Notificaciones',
      route: NotificationsPage.routeName,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isExpanded ? 280 : 80,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            right: BorderSide(color: Theme.of(context).dividerColor, width: 1),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(2, 0),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1),
            _buildNavigationItems(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.account_balance_wallet,
              color: Colors.white,
              size: 24,
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fund Manager',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Sistema de Gestión',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
          IconButton(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon: Icon(
              _isExpanded ? Icons.menu_open : Icons.menu,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationItems() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: _navigationItems.length,
        itemBuilder: (context, index) {
          final item = _navigationItems[index];
          final isSelected = widget.currentRoute == item.route;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  widget.onRouteChanged(item.route);
                  context.go(item.route);
                },
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).primaryColor.withOpacity(0.1)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        item.icon,
                        color: isSelected
                            ? Theme.of(context).primaryColor
                            : Colors.grey[600],
                        size: 24,
                      ),
                      if (_isExpanded) ...[
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey[800],
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}
