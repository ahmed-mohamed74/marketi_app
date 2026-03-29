import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/services/app_state_service.dart';
import 'package:marketi_app/features/onboarding_feature/views/screens/onbourding_screen.dart';

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
          builder: (context, state) => const OnbourdingScreen(),
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

        // 1️⃣ First time → onboarding
        if (isFirstTime && location != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }

        // 2️⃣ Onboarding complete but not logged in → login
        if (!isFirstTime && !isLoggedIn && location != AppRoutes.login) {
          return AppRoutes.login;
        }

        // 3️⃣ Logged in → home
        if (isLoggedIn &&
            (location == AppRoutes.login || location == AppRoutes.onboarding)) {
          return AppRoutes.home;
        }

        return null; // no redirect
      },
    );
  }
}
