import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserSession with ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  static const String isLoggedInKey = 'isLoggedIn';

  Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    notifyListeners();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(isLoggedInKey, value);
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool(isLoggedInKey) ?? false;

    setLoggedIn(isLoggedIn);
  }
}
