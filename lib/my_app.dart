import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/core/themes/app_theme.dart';
import 'package:marketi_app/features/onboarding/presentation/cubit/onbourd_cubit.dart';
import 'package:marketi_app/core/services/service_locator.dart';

class MyApp extends StatelessWidget {
  final AppStateService appStateService;
  final GoRouter router;

  const MyApp({super.key, required this.router, required this.appStateService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnbourdCubit(serviceLocator()),
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
