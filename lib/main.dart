import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/services/api/dio_consumer.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/features/auth_feature/views/bloc/auth_bloc.dart';
import 'package:marketi_app/features/onboarding_feature/views/cubit/onbourd_cubit.dart';
import 'package:provider/provider.dart';
import 'core/services/routing/app_router_service.dart';
import 'core/services/routing/app_state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  CacheHelper().init();
  final appStateService = AppStateService();

  final appRouterService = AppRouterService(appStateService);

  runApp(
    MyApp(router: appRouterService.router, appStateService: appStateService),
  );
}

class MyApp extends StatelessWidget {
  final AppStateService appStateService;
  final GoRouter router;

  const MyApp({super.key, required this.router, required this.appStateService});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appStateService),

        BlocProvider(create: (context) => OnbourdCubit(appStateService)),

        BlocProvider(
          create: (context) => AuthBloc(api: DioConsumer(dio: Dio())),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
      // child: MaterialApp(
      //   home: CongratulationPage(),
      // ),
    );
  }
}
