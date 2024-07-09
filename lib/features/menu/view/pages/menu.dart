import 'package:flutter/material.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc_provider.dart';
import 'package:restaurant_app/features/menu/view/widget/my_bottom_bar.dart';

class SeleccionarMenuApp extends StatelessWidget {
  const SeleccionarMenuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MenuBlocProvider(
      menuBloc: MenuBloc(),
      child: const _SeleccionarMenuApp(),
    );
  }
}

class _SeleccionarMenuApp extends StatelessWidget {
  const _SeleccionarMenuApp();

  @override
  Widget build(BuildContext context) {
    final seleccionarMenuBloc = MenuBlocProvider.of(context)!.menuBloc;
    return AnimatedBuilder(
      animation: seleccionarMenuBloc,
      builder: (context, child) {
        return MaterialApp(
          title: 'Seleccionar Menu',
          debugShowCheckedModeBanner: false,
          themeMode: seleccionarMenuBloc.themeMode,
          darkTheme: ThemeData.from(
            colorScheme: ColorScheme.dark(
              surface: const Color.fromARGB(
                  255, 20, 20, 20), // Fondo principal oscuro
              primary: Colors.red.shade700, // Rojo dominante del logo
              secondary: Colors.white,
              tertiary: const Color.fromARGB(255, 53, 53, 53),
              inversePrimary: const Color.fromARGB(
                  255, 99, 97, 97), // Para contrastes claros
            ),
          ),
          theme: ThemeData.from(
            colorScheme: ColorScheme.light(
              surface: Colors.white, // Fondo principal claro
              primary: Colors.red.shade700, // Rojo dominante del logo
              secondary: Colors.black, // Negro del logo
              tertiary: const Color.fromARGB(
                  255, 25, 25, 25), // Versión más clara del rojo para acentos
              inversePrimary: Colors.grey.shade700, // Para contrastes oscuros
            ),
          ),
          home: child,
        );
      },
      child: const MenuNavigationScreen(),
    );
  }
}
