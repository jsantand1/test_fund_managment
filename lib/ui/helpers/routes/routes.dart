import 'package:go_router/go_router.dart';
import 'package:test_fund_managment/shared/components/layout/main_layout.dart';
import 'package:test_fund_managment/ui/pages/funds/funds_page.dart';
import 'package:test_fund_managment/ui/pages/notifications/notifications_page.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: FundsPage.routeName,
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: FundsPage.routeName,
            name: 'funds',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: FundsPage(),
            ),
          ),
          GoRoute(
            path: NotificationsPage.routeName,
            name: 'notifications',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NotificationsPage(),
            ),
          ),
        ],
      ),
    ],
  );
}