import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:marketi_app/core/api/api_consumer.dart';
import 'package:marketi_app/core/api/dio_consumer.dart';
import 'package:marketi_app/core/routing/app_state_service.dart';
import 'package:marketi_app/features/auth_feature/data/repositories/auth_repository.dart';
import 'package:marketi_app/features/home_feature/data/repositories/home_repository.dart';
import 'package:marketi_app/features/profile_feature/data/repositories/profile_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> serviceLocatorInit() async {
  // Core
  serviceLocator.registerLazySingleton(() => Dio());

  serviceLocator.registerLazySingleton<ApiConsumer>(
    () => DioConsumer(dio: serviceLocator()),
  );

  // App State
  serviceLocator.registerLazySingleton(() => AppStateService());

  // Repositories
  serviceLocator.registerLazySingleton(
    () => AuthRepository(api: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => HomeRepository(api: serviceLocator()),
  );
  serviceLocator.registerLazySingleton(
    () => ProfileRepository(api: serviceLocator()),
  );
}
