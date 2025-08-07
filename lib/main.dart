import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/helpers/routes/routes.dart';
import 'config/service_locator.dart';
import 'ui/bloc/notifications/notifications_bloc.dart';
import 'ui/bloc/funds/funds_bloc.dart';

void main() {
  setUpLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => NotificationsBloc()),
        BlocProvider(create: (context) => FundsBloc()),
      ],
      child: MaterialApp.router(
        title: 'Fund Management System',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        routerConfig: AppRoutes.router,
      ),
    );
  }
}
