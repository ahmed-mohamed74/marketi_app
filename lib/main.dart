import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/services/app_router_service.dart';
import 'package:marketi_app/core/services/app_state_service.dart';

void main() {
  final appStateService = AppStateService();
  final appRouterService = AppRouterService(appStateService);

  runApp(MyApp(router: appRouterService.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}