import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/app/global/view/components/cargando_pagina.dart';
import 'package:restaurant_app/features/auth/dominio/casos_uso/empleado/obtener_empleado.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/bienvenida_bloc.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/bienvenida_event.dart';
import 'package:restaurant_app/features/auth/presentacion/bloc/bienvenida_state.dart';
import 'package:restaurant_app/view/pages/menu.dart';

class BienvenidaPagina extends StatelessWidget {
  static const routeName = '/';

  const BienvenidaPagina({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BienvenidaBloc(
        obtenerEmpleadoCasoDeUso: context.read<ObtenerEmpleadoCasodeUso>()
      )..add(CheckAuthEvent()),
      child: Scaffold(
        body: BlocListener<BienvenidaBloc, BienvenidaState>(
          listener: (context, state) {
            if (state is BienvenidaAuthenticated) {
              Navigator.pushReplacementNamed(context, SeleccionarMenu.routeName);
            } else if (state is BienvenidaUnauthenticated) {
            }
          },
          child: BlocBuilder<BienvenidaBloc, BienvenidaState>(
            builder: (context, state) {
              if (state is LoadingPage) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return const Center(
                child: Text('Bienvenido a la aplicación!'),
              );
            },
          ),
        ),
      ),
    );
  }
}
