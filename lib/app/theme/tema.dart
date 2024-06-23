import 'package:flutter/material.dart';
import 'package:restaurant_app/app/theme/modo_claro.dart';
import 'package:restaurant_app/app/theme/modo_oscuro.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = modoClaro;

  ThemeData get themeData => _themeData;

  bool get isDarkMode => _themeData == modoOscuro;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == modoClaro) {
      themeData = modoOscuro;
    } else {
      themeData = modoClaro;
    }
  }
}