import 'package:flutter/material.dart';

ThemeData modoClaro = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white, // Fondo principal claro
    primary: Colors.red.shade700, // Rojo dominante del logo
    secondary: Colors.black, // Negro del logo
    tertiary: const Color.fromARGB(
        255, 25, 25, 25), // Versión más clara del rojo para acentos
    inversePrimary: Colors.grey.shade700, // Para contrastes oscuros
  ),
);
