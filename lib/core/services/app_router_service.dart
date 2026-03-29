import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/services/app_state_service.dart';


class AppRouterService {
  final AppStateService appStateService;

  late final GoRouter router;

  AppRouterService(this.appStateService) {
    router = GoRouter(
      initialLocation: AppRoutes.splash,

      refreshListenable: appStateService, // for auth changes

      routes: [
        GoRoute(
          path: AppRoutes.splash,
          builder: (context, state) => Placeholder(),
        ),

        GoRoute(
          path: AppRoutes.onboarding,
          builder: (context, state) => Placeholder(),
        ),

        GoRoute(
          path: AppRoutes.login,
          builder: (context, state) => Placeholder(),
        ),

        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Placeholder(),
        ),
      ],

      redirect: (context, state) {
        final isFirstTime = appStateService.getFirstTime();
        final isLoggedIn = appStateService.getLoggedIn();

        final isGoingToOnboarding =
            state.matchedLocation == AppRoutes.onboarding;

        final isGoingToLogin =
            state.matchedLocation == AppRoutes.login;

        // 1. First time → onboarding
        if (isFirstTime && !isGoingToOnboarding) {
          return AppRoutes.onboarding;
        }

        // 2. Not logged in → login
        if (!isLoggedIn && !isGoingToLogin) {
          return AppRoutes.login;
        }

        // 3. Logged in → home
        if (isLoggedIn &&
            (isGoingToLogin || isGoingToOnboarding)) {
          return AppRoutes.home;
        }

        return null;
      },
    );
  }
}