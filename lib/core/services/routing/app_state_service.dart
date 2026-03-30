import 'package:flutter/material.dart';

class AppStateService extends ChangeNotifier {
  bool isFirstTime = true;
  bool isLoggedIn = false;

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