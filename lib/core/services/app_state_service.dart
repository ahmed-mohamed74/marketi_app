import 'package:flutter/material.dart';

class AppStateService extends ChangeNotifier {
  bool isFirstTime = true;
  bool isLoggedIn = false;

  Future<void> init() async {
    await Future.delayed(const Duration(seconds: 2));
  }

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