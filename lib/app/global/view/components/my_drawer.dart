import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurant_app/app/global/view/components/my_drawer_tile.dart';
import 'package:restaurant_app/features/auth/presentacion/paginas/configuracion_pagina.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/inicio_pagina.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // logo
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Image.asset(height: 170, "assets/restaurant.png"),
          ),

          const SizedBox(height: 25),
          // home list tile
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: Divider(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),

          // Lista de Opciones
          // inicio
          MyDrawerTile(
            text: "Inicio",
            icon: Icons.home,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InicioPagina(),
                  ));
            },
          ),

          // configuracion
          MyDrawerTile(
            text: "Configuracion",
            icon: Icons.settings,
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ConfiguracionPagina(),
                  ));
            },
          ),
          const Spacer(),
          // logout
          MyDrawerTile(
            text: "Cerrar Sesión",
            icon: Icons.logout,
            onTap: () {
              // Mostrar un cuadro de diálogo de confirmación antes de cerrar la aplicación
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text("Confirmar"),
                    content: const Text(
                        "¿Estás seguro de que deseas cerrar la sesión?"),
                    actions: <Widget>[
                      TextButton(
                        child: const Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Cerrar Sesión"),
                        onPressed: () {
                          Navigator.of(context).pop();
                          if (Platform.isAndroid) {
                            SystemNavigator.pop();
                          } else if (Platform.isIOS) {
                            exit(0);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }
}
