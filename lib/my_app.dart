import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/core/themes/app_theme.dart';
import 'package:marketi_app/features/home/presentation/cubits/navigation_cubit/navigation_cubit.dart';
import 'package:marketi_app/features/home/presentation/cubits/theme_cubit/theme_cubit.dart';
import 'package:marketi_app/features/onboarding/presentation/cubit/onbourd_cubit.dart';
import 'package:marketi_app/core/services/service_locator.dart';

class MyApp extends StatelessWidget {
  final AppStateService appStateService;
  final GoRouter router;

  const MyApp({super.key, required this.router, required this.appStateService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnbourdCubit(serviceLocator())),
        BlocProvider(create: (context) => NavigationCubit()),
        BlocProvider(create: (context) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.light,
            debugShowCheckedModeBanner: false,
            routerConfig: router,
          );
        },
      ),
    );
  }
}
