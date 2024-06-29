import 'package:flutter/material.dart';

ThemeData modoClaro = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.white, // Fondo principal claro
    primary: Colors.red.shade700, // Rojo dominante del logo
    secondary: Colors.black, // Negro del logo
    tertiary: Colors.red.shade100, // Versión más clara del rojo para acentos
    inversePrimary: Colors.grey.shade700, // Para contrastes oscuros
  ),
);