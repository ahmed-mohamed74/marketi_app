import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';
import 'package:marketi_app/core/services/payment/stripe_payment/stripe_keys.dart';
import 'package:marketi_app/my_app.dart';
import 'package:marketi_app/core/services/service_locator.dart';
import 'core/routing/app_router_service.dart';
import 'core/routing/app_state_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = StripeKeys.publishableKey;
  await serviceLocatorInit();
  CacheHelper().init();
  final appStateService = serviceLocator<AppStateService>();
  final router = AppRouterService(appStateService).router;
  runApp(MyApp(router: router, appStateService: appStateService));
}
