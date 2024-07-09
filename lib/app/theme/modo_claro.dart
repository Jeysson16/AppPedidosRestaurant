import 'package:flutter/material.dart';

ThemeData modoClaro = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white, // Fondo principal claro
    primary: Colors.red.shade700, // Rojo dominante del logo
    secondary: Colors.black, // Negro del logo
    tertiary: Color.fromARGB(
        255, 226, 222, 222), // Versión más clara del rojo para acentos
    inversePrimary:
        const Color.fromARGB(255, 219, 219, 219), // Para contrastes oscuros
  ),
);
