import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:marketi_app/features/onboarding_feature/view_model/cubit/onbourd_cubit.dart';
import 'core/services/app_router_service.dart';
import 'core/services/app_state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OnbourdCubit(appStateService)),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
