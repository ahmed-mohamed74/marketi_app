import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/dio_consumer.dart';
import 'package:marketi_app/core/network/connection_checker.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/core/services/cache/product_local_data_source.dart';
import 'package:marketi_app/features/auth/data/repositories/auth_repository.dart';
import 'package:marketi_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/add_product_cubit/add_product_cubit.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/delete_product_cubit/delete_product_cubit.dart';
import 'package:marketi_app/features/cart/presentation/cart_cubits/get_product_cubit/get_products_cubit.dart';
import 'package:marketi_app/features/checkout/presentation/payment_cubit/payment_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/add_favourite_cubit/add_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/delete_favourite_cubit/delete_favourite_cubit.dart';
import 'package:marketi_app/features/favorite/presentation/favourite_cubits/get_favourites_cubit/get_favourites_cubit.dart';
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:marketi_app/features/home/data/models/category_name_model.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/cart/data/repositories/cart_repository.dart';
import 'package:marketi_app/features/favorite/data/repositories/favourite_repository.dart';
import 'package:marketi_app/features/home/data/repositories/home_repository.dart';
import 'package:marketi_app/features/home/presentation/cubits/home_cubit/home_cubit.dart';
import 'package:marketi_app/features/order/data/models/order_model.dart';
import 'package:marketi_app/features/order/data/repositories/order_local_service.dart';
import 'package:marketi_app/features/order/presentation/cubit/order_cubit.dart';
import 'package:marketi_app/features/profile/data/repositories/profile_repository.dart';
import 'package:marketi_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final serviceLocator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // 1. External & Core (Hive, Dio, Internet)
  await _initCore();

  // 2. Data Sources
  _initDataSources();

  // 3. Repositories
  _initRepositories();

  // 4. Cubits (Business Logic)
  _initCubits();
}

Future<void> _initCore() async {
  await Hive.initFlutter();

  // Adapters
  _registerHiveAdapters();

  // Boxes
  final productBox = await Hive.openBox<ProductModel>('products');
  final categoryBox = await Hive.openBox<CategoryModel>('categories');
  final brandBox = await Hive.openBox<BrandModel>('brands');
  final categoryNameBox = await Hive.openBox<CategoryNameModel>(
    'categoriesNames',
  );
  final cartProductBox = await Hive.openBox<ProductModel>('cartProducts');
  final favProductBox = await Hive.openBox<ProductModel>('favProducts');
  final ordersBox = await Hive.openBox<OrderModel>('orders_box');

  // Register Boxes
  serviceLocator.registerLazySingleton<Box<ProductModel>>(
    () => productBox,
    instanceName: 'productsBox',
  );
  serviceLocator.registerLazySingleton<Box<CategoryModel>>(() => categoryBox);
  serviceLocator.registerLazySingleton<Box<BrandModel>>(() => brandBox);
  serviceLocator.registerLazySingleton<Box<CategoryNameModel>>(
    () => categoryNameBox,
  );
  serviceLocator.registerLazySingleton<Box<ProductModel>>(
    () => cartProductBox,
    instanceName: 'cartBox',
  );
  serviceLocator.registerLazySingleton<Box<ProductModel>>(
    () => favProductBox,
    instanceName: 'favBox',
  );
  serviceLocator.registerLazySingleton<Box<OrderModel>>(() => ordersBox);

  // Network & API
  serviceLocator.registerLazySingleton(() => Dio());
  serviceLocator.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(() => InternetConnection());
  serviceLocator.registerLazySingleton<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  final sharedPrefs = await SharedPreferences.getInstance();
  serviceLocator.registerSingleton<SharedPreferences>(sharedPrefs);

  serviceLocator.registerLazySingleton(
    () => AppStateService(serviceLocator<SharedPreferences>()),
  );
}

void _registerHiveAdapters() {
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(DimensionsAdapter());
  Hive.registerAdapter(ReviewsAdapter());
  Hive.registerAdapter(MetaAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(BrandModelAdapter());
  Hive.registerAdapter(CategoryNameModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
}

void _initDataSources() {
  serviceLocator.registerLazySingleton<ProductLocalDataSource>(
    () => ProductLocalDataSource(
      productBox: serviceLocator(instanceName: 'productsBox'),
      categoryBox: serviceLocator(),
      brandBox: serviceLocator(),
      categoryNameBox: serviceLocator(),
      cartBox: serviceLocator(instanceName: 'cartBox'),
      favoriteBox: serviceLocator(instanceName: 'favBox'),
    ),
  );
  serviceLocator.registerLazySingleton<OrderLocalService>(
    () => OrderLocalService(),
  );
}

void _initRepositories() {
  serviceLocator.registerLazySingleton(
    () => AuthRepository(serviceLocator(), serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => HomeRepository(
      api: serviceLocator(),
      productLocalDataSource: serviceLocator(),
      connectionChecker: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => ProfileRepository(api: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => CartRepository(
      api: serviceLocator(),
      connectionChecker: serviceLocator(),
      productLocalDataSource: serviceLocator(),
    ),
  );
  serviceLocator.registerLazySingleton(
    () => FavouriteRepository(
      api: serviceLocator(),
      connectionChecker: serviceLocator(),
      productLocalDataSource: serviceLocator(),
    ),
  );
}

void _initCubits() {
  serviceLocator.registerLazySingleton(
    () => AuthBloc(authRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => HomeCubit(homeRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetProductsCubit(cartRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AddProductCubit(cartRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteProductCubit(cartRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => GetFavouriteCubit(favouriteRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => AddFavouriteCubit(favouriteRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => DeleteFavouriteCubit(favouriteRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ProfileCubit(profileRepository: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => PaymentCubit(orderLocalService: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => OrderCubit(orderLocalService: serviceLocator()),
  );
}
