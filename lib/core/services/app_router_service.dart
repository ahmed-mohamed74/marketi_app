import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/services/app_state_service.dart';

class AppRouterService {
  final AppStateService appStateService;

  late final GoRouter router;

  AppRouterService(this.appStateService) {
    router = GoRouter(
      initialLocation: AppRoutes.onboarding, 

      refreshListenable: appStateService,

      routes: [
        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => const Placeholder(),
        ),

        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => const Placeholder(),
        ),

        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Placeholder(),
        ),
      ],

      redirect: (context, state) {
        final isFirstTime = appStateService.getFirstTime();
        final isLoggedIn = appStateService.getLoggedIn();

        final location = state.matchedLocation;

        // 🔥 First time → onboarding
        if (isFirstTime && location != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }

        // 🔥 Not logged in → login
        if (!isLoggedIn && location != AppRoutes.login) {
          return AppRoutes.login;
        }

        // 🔥 Logged in → home
        if (isLoggedIn &&
            (location == AppRoutes.login ||
             location == AppRoutes.onboarding)) {
          return AppRoutes.home;
        }

        return null;
      },
    );
  }
}