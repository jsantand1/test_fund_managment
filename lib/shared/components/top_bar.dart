import 'package:flutter/material.dart';
import 'package:test_fund_managment/ui/helpers/utils/responsive.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  final String userName;
  final String userEmail;
  final bool isOnline;

  const TopBar({
    super.key,
    this.userName = 'Juan Pérez',
    this.userEmail = 'juan.perez@fundmanager.com',
    this.isOnline = true,
  });

  @override
  Widget build(BuildContext context) {
    // Don't show TopBar on mobile (using AppBar instead)
    if (Responsive.isMobile(context)) {
      return const SizedBox.shrink();
    }
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                // Spacer para empujar el contenido a la derecha
                const Spacer(),
                
                // User info section
                Row(
                  children: [
                    // User avatar with online indicator
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.grey[300],
                          child: Icon(
                            Icons.person,
                            size: 24,
                            color: Colors.grey[600],
                          ),
                        ),
                        // Online indicator
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: isOnline ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.surface,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 12),
                    
                    // User info
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: isOnline ? Colors.green : Colors.grey,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isOnline ? 'En línea' : 'Desconectado',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isOnline ? Colors.green : Colors.grey[600],
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Dropdown menu
                    PopupMenuButton<String>(
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                      onSelected: (value) => _handleMenuAction(value),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'profile',
                          child: ListTile(
                            leading: const Icon(Icons.person_outline),
                            title: const Text('Mi Perfil'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        PopupMenuItem(
                          value: 'settings',
                          child: ListTile(
                            leading: const Icon(Icons.settings_outlined),
                            title: const Text('Configuración'),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                        const PopupMenuDivider(),
                        PopupMenuItem(
                          value: 'logout',
                          child: ListTile(
                            leading: const Icon(Icons.logout, color: Colors.red),
                            title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.red)),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'profile':
        // TODO: Navigate to profile page
        break;
      case 'settings':
        // TODO: Navigate to settings page
        break;
      case 'logout':
        // TODO: Handle logout
        break;
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(81);
}
