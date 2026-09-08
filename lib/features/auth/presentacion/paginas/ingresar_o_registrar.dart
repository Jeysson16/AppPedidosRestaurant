import 'package:flutter/material.dart';
import 'package:restaurant_app/features/auth/presentacion/paginas/ingresar_pagina.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/inicio_anonimo_pagina.dart';
import 'package:restaurant_app/features/auth/presentacion/paginas/registrar_usuario_pagina.dart';

class IngresarORegistrar extends StatefulWidget {
  const IngresarORegistrar({super.key});

  @override
  State<IngresarORegistrar> createState() => _IngresarORegistrarState();
}

class _IngresarORegistrarState extends State<IngresarORegistrar> {
  // inicializacion mostrar pagina
  // La vista de invitado permite revisar el catálogo aun sin credenciales.
  bool mostrarIniciarSesion = false;
  bool mostrarAnonimo = true;

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
