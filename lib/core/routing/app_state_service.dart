import 'package:flutter/material.dart';
import 'package:marketi_app/core/api/end_points.dart';
import 'package:marketi_app/core/services/cache/cache_helper.dart';

class AppStateService extends ChangeNotifier {
  bool getFirstTime() {
    return CacheHelper().getData(key: 'isFirstTime') ?? true;
  }

  bool getLoggedIn() {
    String? token = CacheHelper().getData(key: ApiKey.token);
    return token != null;
  }

  void login() {
    notifyListeners();
  }

  void completeOnboarding() async {
    await CacheHelper().saveData(key: 'isFirstTime', value: false);
    notifyListeners();
  }

  void updateAuthState() {
    notifyListeners();
  }
}
