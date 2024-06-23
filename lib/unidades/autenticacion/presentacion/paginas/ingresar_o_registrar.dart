import 'package:flutter/material.dart';
import 'package:restaurant_app/unidades/autenticacion/presentacion/paginas/ingresar_pagina.dart';
import 'package:restaurant_app/unidades/pedidos/presentacion/pages/inicio_anonimo_pagina.dart';
import 'package:restaurant_app/unidades/autenticacion/presentacion/paginas/registrar_usuario_pagina.dart';

class IngresarORegistrar extends StatefulWidget {
  const IngresarORegistrar({super.key});

  @override
  State<IngresarORegistrar> createState() => _IngresarORegistrarState();
}

class _IngresarORegistrarState extends State<IngresarORegistrar> {
  // inicializacion mostrar pagina
  bool mostrarIniciarSesion = true;
  bool mostrarAnonimo = false;

  // cambio entre entrar o registrarse el usuario
  void togglePages() {
    setState(() {
      mostrarIniciarSesion = !mostrarIniciarSesion;
    });
  }

  // entrar como sin cuenta
  void anonimoTogglePages() {
    setState(() {
      mostrarIniciarSesion = !mostrarIniciarSesion;
      mostrarAnonimo = !mostrarAnonimo;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (mostrarIniciarSesion) {
      return Entrar(onRegisterTap: togglePages, onGuestTap: anonimoTogglePages);
    }else if(mostrarIniciarSesion==false && mostrarAnonimo==true){
      return const InicioAnonimoPagina();
    }else{
      return RegistrarUsuarioPagina(onTap: togglePages);
    }
  }
}