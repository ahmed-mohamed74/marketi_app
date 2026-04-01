import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/constants/app_routes.dart';
import 'package:marketi_app/core/services/routing/app_state_service.dart';
import 'package:marketi_app/features/auth_feature/views/screens/reset_password_pages/congratulation_page.dart';
import 'package:marketi_app/features/auth_feature/views/screens/login_page.dart';
import 'package:marketi_app/features/auth_feature/views/screens/reset_password_pages/new_password_page.dart';
import 'package:marketi_app/features/auth_feature/views/screens/reset_password_pages/reset_password_page.dart';
import 'package:marketi_app/features/auth_feature/views/screens/sign_up_screen.dart';
import 'package:marketi_app/features/auth_feature/views/screens/reset_password_pages/verification_code_page.dart';
import 'package:marketi_app/features/onboarding_feature/views/screens/onbourding_screen.dart';
import 'package:marketi_app/features/profile_feature/views/screens/profile_page.dart';

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
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          builder: (context, state) => const SignUpPage(),
        ),
        GoRoute(
          path: AppRoutes.resetPage,
          builder: (context, state) => const ResetPasswordPage(),
        ),
        GoRoute(
          path: AppRoutes.verificationPage,
          builder: (context, state) {
            final email = state.extra as String?;
            return VerificationCodePage(email: email ?? '');
          },
        ),
        GoRoute(
          path: AppRoutes.newPasswordPage,
          builder: (context, state) {
            final email = state.extra as String?;
            return NewPasswordPage(email: email ?? '');
          },
        ),
        GoRoute(
          path: AppRoutes.congratulationPage,
          builder: (context, state) => const CongratulationPage(),
        ),

        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const Placeholder(),
        ),
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfilePage(),
        ),
      ],

      redirect: (context, state) {
        final isFirstTime = appStateService.getFirstTime();
        final isLoggedIn = appStateService.getLoggedIn();
        final location = state.matchedLocation;

        // Always allow onboarding, login, signup, and reset pages without redirecting
        const allowedWithoutRedirect = [
          AppRoutes.onboarding,
          AppRoutes.login,
          AppRoutes.signUp,
          AppRoutes.resetPage,
        ];

        // 1️⃣ First time → onboarding
        if (isFirstTime && location != AppRoutes.onboarding) {
          return AppRoutes.onboarding;
        }

        // 2️⃣ Not logged in → login (unless on allowed pages)
        if (!isFirstTime &&
            !isLoggedIn &&
            !allowedWithoutRedirect.contains(location)) {
          return AppRoutes.login;
        }

        // 3️⃣ Logged in → home (cannot go to auth/onboarding pages)
        // if (isLoggedIn && allowedWithoutRedirect.contains(location)) {
        //   return AppRoutes.home;
        // }
        //Todo: remove this
        if (isLoggedIn && allowedWithoutRedirect.contains(location)) {
          return AppRoutes.profile;
        }

        return null; // no redirect
      },
    );
  }
}
