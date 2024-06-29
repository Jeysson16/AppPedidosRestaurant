import 'package:flutter/material.dart';

ThemeData modoOscuro = ThemeData(
  colorScheme: ColorScheme.dark(
    surface: const Color.fromARGB(255, 20, 20, 20), // Fondo principal oscuro
    primary: Colors.red.shade700, // Rojo dominante del logo
    secondary: Colors.white, // Blanco para texto y acentos
    tertiary: Colors.red.shade100, // Versión más clara del rojo para acentos
    inversePrimary: Colors.grey.shade300, // Para contrastes claros
  ),
);
