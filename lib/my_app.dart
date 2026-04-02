import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/core/services/api/dio_consumer.dart';
import 'package:marketi_app/core/services/routing/app_state_service.dart';
import 'package:marketi_app/core/themes/app_theme.dart';
import 'package:marketi_app/features/auth_feature/view_model/repositories/auth_repository.dart';
import 'package:marketi_app/features/auth_feature/views/bloc/auth_bloc.dart';
import 'package:marketi_app/features/home_feature/views/bloc/cubit/home_cubit.dart';
import 'package:marketi_app/features/onboarding_feature/views/cubit/onbourd_cubit.dart';
import 'package:provider/provider.dart';

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
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: AuthRepository(api: DioConsumer(dio: Dio())),
          ),
        ),
      ],
      child: MaterialApp.router(
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
      // child: MaterialApp(
      //   theme: AppTheme.lightTheme,
      //   home: BlocProvider(
      //     create: (context) => HomeCubit(),
      //     child: HomePage(),
      //   ),
      // ),
    );
  }
}
