import 'package:flutter/material.dart';

ThemeData modoOscuro = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 20, 20, 20), // Fondo principal oscuro
    primary: Colors.red.shade700, // Rojo dominante del logo
    secondary: Colors.white,
    tertiary: const Color.fromARGB(255, 53, 53, 53),
    inversePrimary: Color.fromARGB(255, 43, 43, 43), // Para contrastes claros
  ),
);
