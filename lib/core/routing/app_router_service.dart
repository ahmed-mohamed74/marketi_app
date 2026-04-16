import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/routing/app_routes.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'package:marketi_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/auth/presentation/screens/reset_password_pages/congratulation_page.dart';
import 'package:marketi_app/features/auth/presentation/screens/login_page.dart';
import 'package:marketi_app/features/auth/presentation/screens/reset_password_pages/new_password_page.dart';
import 'package:marketi_app/features/auth/presentation/screens/reset_password_pages/reset_password_page.dart';
import 'package:marketi_app/features/auth/presentation/screens/sign_up_screen.dart';
import 'package:marketi_app/features/auth/presentation/screens/reset_password_pages/verification_code_page.dart';
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/checkout/presentation/payment_cubit/payment_cubit.dart';
import 'package:marketi_app/features/home/presentation/screens/brand_page.dart';
import 'package:marketi_app/features/home/presentation/screens/category_page.dart';
import 'package:marketi_app/features/checkout/presentation/screens/checkout_page.dart';
import 'package:marketi_app/features/home/presentation/screens/home_page.dart';
import 'package:marketi_app/features/home/presentation/screens/home_pages/all_category_brands_page.dart';
import 'package:marketi_app/features/home/presentation/screens/home_pages/all_products_page.dart';
import 'package:marketi_app/features/home/presentation/screens/product_page.dart';
import 'package:marketi_app/features/onboarding/presentation/screens/onbourding_screen.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:marketi_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:marketi_app/features/order/presentation/screens/order_history.dart';
import 'package:marketi_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:marketi_app/features/profile/presentation/screens/profile_page.dart';

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
          builder: (context, state) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HomeCubit(homeRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddProductCubit(cartRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      GetProductsCubit(cartRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      DeleteProductCubit(cartRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) => DeleteFavouriteCubit(
                    favouriteRepository: serviceLocator(),
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      GetFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
              ],

              child: HomePage(),
            );
          },
        ),

        GoRoute(
          path: AppRoutes.productPage,
          builder: (context, state) {
            final product = state.extra as ProductModel?;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HomeCubit(homeRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddProductCubit(cartRepository: serviceLocator()),
                ),
              ],
              child: ProductDetailsPage(product: product),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.categoryPage,
          builder: (context, state) {
            final categoryName = state.extra as String?;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HomeCubit(homeRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddProductCubit(cartRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) => DeleteFavouriteCubit(
                    favouriteRepository: serviceLocator(),
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      GetFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
              ],
              child: CategoryPage(categoryName: categoryName),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.brandPage,
          builder: (context, state) {
            final brandName = state.extra as String?;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HomeCubit(homeRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddProductCubit(cartRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) => DeleteFavouriteCubit(
                    favouriteRepository: serviceLocator(),
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      GetFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
              ],
              child: BrandPage(brandName: brandName),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.allProductsPage,
          builder: (context, state) {
            final title = state.extra as String;
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      HomeCubit(homeRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddProductCubit(cartRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) =>
                      AddFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
                BlocProvider(
                  create: (context) => DeleteFavouriteCubit(
                    favouriteRepository: serviceLocator(),
                  ),
                ),
                BlocProvider(
                  create: (context) =>
                      GetFavouriteCubit(favouriteRepository: serviceLocator()),
                ),
              ],
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
        GoRoute(
          path: AppRoutes.checkoutPage,
          builder: (context, state) {
            final order = state.extra as OrderModel?;

            return BlocProvider(
              create: (context) =>
                  PaymentCubit(orderLocalService: serviceLocator()),
              child: CheckoutPage(orderModel: order),
            );
          },
        ),
        GoRoute(
          path: AppRoutes.orderHistoryPage,
          builder: (context, state) => BlocProvider(
            create: (context) =>
                OrderCubit(orderLocalService: serviceLocator()),
            child: const OredrHistory(),
          ),
        ),
      ],

      redirect: (context, state) {
        final isFirstTime = appStateService.getFirstTime();
        final isLoggedIn = appStateService.getLoggedIn();
        final location = state.matchedLocation;

        final bool isAuthPage =
            location == AppRoutes.login ||
            location == AppRoutes.signUp ||
            location == AppRoutes.resetPage ||
            location == AppRoutes.verificationPage ||
            location == AppRoutes.newPasswordPage;

        final bool isOnboardingPage = location == AppRoutes.onboarding;

        if (isFirstTime) {
          return isOnboardingPage ? null : AppRoutes.onboarding;
        }

        if (!isLoggedIn) {
          if (isAuthPage || isOnboardingPage) return null;
          return AppRoutes.login;
        }

        if (isLoggedIn && (isAuthPage || isOnboardingPage)) {
          return AppRoutes.home;
        }

        return null; 
      },
    );
  }
}
