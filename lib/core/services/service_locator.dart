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
import 'package:marketi_app/features/home/data/models/brand_model.dart';
import 'package:marketi_app/features/home/data/models/category_model.dart';
import 'package:marketi_app/features/home/data/models/category_name_model.dart';
import 'package:marketi_app/features/home/data/models/product_model.dart';
import 'package:marketi_app/features/cart/data/repositories/cart_repository.dart';
import 'package:marketi_app/features/favorite/data/repositories/favourite_repository.dart';
import 'package:marketi_app/features/home/data/repositories/home_repository.dart';
import 'package:marketi_app/features/profile/data/repositories/profile_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  await Hive.initFlutter();

  // 2. Register your Adapters (Must be done before opening boxes)
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(DimensionsAdapter());
  Hive.registerAdapter(ReviewsAdapter());
  Hive.registerAdapter(MetaAdapter());
  Hive.registerAdapter(CategoryModelAdapter());
  Hive.registerAdapter(BrandModelAdapter());
  Hive.registerAdapter(CategoryNameModelAdapter());

  // 3. Open the Box
  // We open it here so it's ready to be injected as a Singleton
  var productBox = await Hive.openBox<ProductModel>('products');
  var categoryBox = await Hive.openBox<CategoryModel>('categories');
  var brandBox = await Hive.openBox<BrandModel>('brands');
  var categoryNameBox = await Hive.openBox<CategoryNameModel>(
    'categoriesNames',
  );
  var cartProductBox = await Hive.openBox<ProductModel>('cartProducts');
  var favProductBox = await Hive.openBox<ProductModel>('favProducts');

  // 4. Register the Box in GetIt
  serviceLocator.registerLazySingleton<Box<ProductModel>>(
    () => productBox,
    instanceName: 'productsBox',
  );
  serviceLocator.registerLazySingleton<Box<CategoryModel>>(() => categoryBox);
  serviceLocator.registerLazySingleton<Box<BrandModel>>(() => brandBox);
  serviceLocator.registerLazySingleton<Box<CategoryNameModel>>(
    () => categoryNameBox,
  );
  // 4. Register the Boxes with instance names
  serviceLocator.registerLazySingleton<Box<ProductModel>>(
    () => cartProductBox,
    instanceName: 'cartBox',
  );
  serviceLocator.registerLazySingleton<Box<ProductModel>>(
    () => favProductBox,
    instanceName: 'favBox',
  );

  serviceLocator.registerFactory(() => InternetConnection());
  // Core
  serviceLocator.registerLazySingleton(() => Dio());

  serviceLocator.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: serviceLocator()),
  );
  serviceLocator.registerFactory<ConnectionChecker>(
    () => ConnectionCheckerImpl(serviceLocator()),
  );
  serviceLocator.registerFactory<ProductLocalDataSource>(
    () => ProductLocalDataSource(
      productBox: serviceLocator(instanceName: 'productsBox'),
      categoryBox: serviceLocator(),
      brandBox: serviceLocator(),
      categoryNameBox: serviceLocator(),
      cartBox: serviceLocator(instanceName: 'cartBox'),
      favoriteBox: serviceLocator(instanceName: 'favBox'),
    ),
  );

  // App State
  serviceLocator.registerLazySingleton(() => AppStateService());

  // Repositories
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
