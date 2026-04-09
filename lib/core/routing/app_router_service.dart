import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'package:marketi_app/features/auth_feature/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth_feature/presentation/screens/reset_password_pages/congratulation_page.dart';
import 'package:marketi_app/features/auth_feature/presentation/screens/login_page.dart';
import 'package:marketi_app/features/auth_feature/presentation/screens/reset_password_pages/new_password_page.dart';
import 'package:marketi_app/features/auth_feature/presentation/screens/reset_password_pages/reset_password_page.dart';
import 'package:marketi_app/features/auth_feature/presentation/screens/sign_up_screen.dart';
import 'package:marketi_app/features/auth_feature/presentation/screens/reset_password_pages/verification_code_page.dart';
import 'package:marketi_app/features/home_feature/data/models/brand_model.dart';
import 'package:marketi_app/features/home_feature/data/models/category_model.dart';
import 'package:marketi_app/features/home_feature/data/models/product_model.dart';
import 'package:marketi_app/features/home_feature/presentation/cubit/home_cubit.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/brand_page.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/category_page.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/home_page.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/home_pages/all_category_brands_page.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/home_pages/all_products_page.dart';
import 'package:marketi_app/features/home_feature/presentation/screens/product_page.dart';
import 'package:marketi_app/features/onboarding_feature/presentation/screens/onbourding_screen.dart';
import 'package:marketi_app/features/profile_feature/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile_feature/presentation/screens/profile_page.dart';

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
          builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(authRepository: serviceLocator()),
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.signUp,
          builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(authRepository: serviceLocator()),
            child: const SignUpPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.resetPage,
          builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(authRepository: serviceLocator()),
            child: const ResetPasswordPage(),
          ),
        ),
        GoRoute(
          path: AppRoutes.verificationPage,
          builder: (context, state) {
            final email = state.extra as String?;
            return BlocProvider(
              create: (context) => AuthBloc(authRepository: serviceLocator()),
              child: VerificationCodePage(email: email ?? ''),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.newPasswordPage,
          builder: (context, state) {
            final email = state.extra as String?;
            return BlocProvider(
              create: (context) => AuthBloc(authRepository: serviceLocator()),
              child: NewPasswordPage(email: email ?? ''),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.congratulationPage,
          builder: (context, state) => BlocProvider(
            create: (context) => AuthBloc(authRepository: serviceLocator()),
            child: const CongratulationPage(),
          ),
        ),

        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => BlocProvider(
            create: (context) => HomeCubit(homeRepository: serviceLocator()),
            child: const HomePage(),
          ),
        ),

        GoRoute(
          path: AppRoutes.productPage,
          builder: (context, state) {
            final product = state.extra as ProductModel?;
            return BlocProvider(
              create: (context) => HomeCubit(homeRepository: serviceLocator()),
              child: ProductDetailsPage(product: product),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.categoryPage,
          builder: (context, state) {
            final categoryName=state.extra as String?;
            return BlocProvider(
              create: (context) => HomeCubit(homeRepository: serviceLocator()),
              child: CategoryPage(categoryName: categoryName,),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.brandPage,
          builder: (context, state) {
            final brandName=state.extra as String?;
            return BlocProvider(
              create: (context) => HomeCubit(homeRepository: serviceLocator()),
              child: BrandPage(brandName: brandName,),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.allProductsPage,
          builder: (context, state) {
            final title = state.extra as String;
            return BlocProvider(
              create: (context) => HomeCubit(homeRepository: serviceLocator()),
              child: AllProductsPage(appBarTitle: title),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.allCategoryBrandsPage,
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;

            final title = data['title'] as String;
            final categoryItems = data['categoryItems'] as List<CategoryModel>;
            final brandItems = data['brandItems'] as List<BrandModel>;
            return BlocProvider(
              create: (context) => HomeCubit(homeRepository: serviceLocator()),
              child: AllCategoryBrandsPage(
                appBarTitle: title,
                categoryItems: categoryItems,
                brandItems: brandItems,
              ),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => BlocProvider(
            create: (context) =>
                ProfileCubit(profileRepository: serviceLocator()),
            child: const ProfilePage(),
          ),
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
        if (isLoggedIn && allowedWithoutRedirect.contains(location)) {
          return AppRoutes.home;
        }

        return null; // no redirect
      },
    );
  }
}
