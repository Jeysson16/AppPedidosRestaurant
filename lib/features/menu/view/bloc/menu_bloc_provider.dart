import 'package:flutter/material.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc.dart';

class MenuBlocProvider extends InheritedWidget {
  const MenuBlocProvider({
    super.key,
    required this.menuBloc,
    required super.child,
  });

  final MenuBloc menuBloc;

  static MenuBlocProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<MenuBlocProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => this != oldWidget;
}
