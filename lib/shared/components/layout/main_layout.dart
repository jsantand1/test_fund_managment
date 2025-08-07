import 'package:flutter/material.dart';
import '../sidebar_menu.dart';
import '../top_bar.dart';
import '../../../ui/pages/funds/funds_page.dart';
import '../../../ui/helpers/utils/responsive.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  String _currentRoute = FundsPage.routeName;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onRouteChanged(String route) {
    setState(() {
      _currentRoute = route;
    });
    
    // Close drawer on mobile after navigation
    if (Responsive.isMobile(context) && _scaffoldKey.currentState?.isDrawerOpen == true) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      mobile: _buildMobileLayout(),
      tablet: _buildTabletLayout(),
      desktop: _buildDesktopLayout(),
    );
  }

  /// Mobile layout with drawer
  Widget _buildMobileLayout() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Fund Manager'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 1,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          // User info in mobile top bar
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                  child: Icon(
                    Icons.person,
                    size: 18,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SidebarMenu(
          currentRoute: _currentRoute,
          onRouteChanged: _onRouteChanged,
          isMobile: true,
        ),
      ),
      body: ResponsivePadding(
        mobile: const EdgeInsets.all(16),
        child: widget.child,
      ),
    );
  }

  /// Tablet layout with collapsible sidebar
  Widget _buildTabletLayout() {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            currentRoute: _currentRoute,
            onRouteChanged: _onRouteChanged,
            isTablet: true,
          ),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: ResponsivePadding(
                    tablet: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: Responsive.getMaxContentWidth(context),
                      ),
                      child: widget.child,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Desktop layout with full sidebar and max content width
  Widget _buildDesktopLayout() {
    return Scaffold(
      body: Row(
        children: [
          SidebarMenu(
            currentRoute: _currentRoute,
            onRouteChanged: _onRouteChanged,
          ),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: Responsive.getMaxContentWidth(context),
                      ),
                      child: ResponsivePadding(
                        desktop: const EdgeInsets.all(24),
                        largeDesktop: const EdgeInsets.all(32),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
