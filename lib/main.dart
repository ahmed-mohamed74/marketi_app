import 'package:flutter/material.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/my_app.dart';
import 'core/services/routing/app_router_service.dart';
import 'core/services/routing/app_state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();
  final appStateService = AppStateService();
  final appRouterService = AppRouterService(appStateService);
  runApp(
    MyApp(router: appRouterService.router, appStateService: appStateService),
  );
}
