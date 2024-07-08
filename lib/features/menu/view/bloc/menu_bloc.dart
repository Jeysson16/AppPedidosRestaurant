import 'package:flutter/material.dart';

enum SettingsState { visible, hide }

enum ViewState { ample, clean, old }

class MenuBloc with ChangeNotifier {
  SettingsState settingState = SettingsState.hide;
  ViewState viewState = ViewState.ample;
  ThemeMode themeMode = ThemeMode.light;

  void showSettings() {
    settingState = SettingsState.visible;
    notifyListeners();
  }

  void hideSettings() {
    settingState = SettingsState.hide;
    notifyListeners();
  }

  void changeView(ViewState state) {
    viewState = state;
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    themeMode = mode;
    notifyListeners();
  }
}
