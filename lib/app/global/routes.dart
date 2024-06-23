import 'package:flutter/material.dart';
import 'package:restaurant_app/unidades/autenticacion/presentacion/paginas/bienvenida_pagina.dart';

class AppRoutes {
  static Map<String, WidgetBuilder> get routes {
    return {

      BienvenidaPagina.routeName: (context) => const BienvenidaPagina(),

    };
  }
}
