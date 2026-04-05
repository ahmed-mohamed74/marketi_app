import 'package:flutter/material.dart';

class AppStateService extends ChangeNotifier {
  /////////////////
  bool isFirstTime = false;
  bool isLoggedIn = true;

  bool getFirstTime() => isFirstTime;
  bool getLoggedIn() => isLoggedIn;

  void completeOnboarding() {
    isFirstTime = false;
    notifyListeners();
  }

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }
}
