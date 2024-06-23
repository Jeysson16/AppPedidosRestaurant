import 'package:flutter/material.dart';
import 'package:restaurant_app/unidades/autenticacion/presentacion/paginas/registrar_pagina.dart';
import 'package:restaurant_app/view/pages/mesas/seleccionar_mesa.dart';
import 'package:restaurant_app/view/pages/productos/registrar_productos.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';

class SeleccionarMenu extends StatefulWidget {
  static const routeName = '/';
  const SeleccionarMenu({super.key});

  @override
  _SeleccionarMenuState createState() => _SeleccionarMenuState();
}

class _SeleccionarMenuState extends State<SeleccionarMenu> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
    final empleado = preferenciasUsuario.empleado;
    if(empleado == null){

    }else{
      final String empleadoNombres = empleado.nombres;
      final empleadoApellido = empleado.apellidos;
    }
    final List<String>? permisos = preferenciasUsuario.permisos;

    final List<Widget> pages = [
      const SeleccionarMesaPage(),
      const Placeholder(),
      const Placeholder(),
      const Placeholder(),
      const RegistrarProductoPage(),
      const RegistrarEmpleadoPagina(),
    ];

    final List<BottomNavigationBarItem> navItems = permisos?.map((permiso) {
      return BottomNavigationBarItem(
        icon: Icon(permissionIcons[permiso] ?? Icons.help),
        label: permissionTitles[permiso] ?? permiso,
      );
    }).toList() ?? []; // Provide an empty list if permisos is null

    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: IndexedStack(
        index: _selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: navItems,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        backgroundColor: Colors.grey[200],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            ListTile(
              title: const Text('Opción 1'),
              onTap: () {
                // Implementa la funcionalidad de la primera opción del drawer
              },
            ),
            ListTile(
              title: const Text('Opción 2'),
              onTap: () {
                // Implementa la funcionalidad de la segunda opción del drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}

const permissionIcons = {
  'tomar_pedidos': Icons.assignment,
  'gestionar_mesas': Icons.table_chart,
  'administrar_productos': Icons.storage,
  'ver_reportes': Icons.analytics,
  'preparar_comida': Icons.kitchen,
  'confirmar_ordenes': Icons.check,
  'registrar_productos': Icons.add_shopping_cart,
};

const permissionTitles = {
  'tomar_pedidos': 'Tomar Pedidos',
  'gestionar_mesas': 'Gestionar Mesas',
  'administrar_productos': 'Administrar Productos',
  'ver_reportes': 'Ver Reportes',
  'preparar_comida': 'Preparar Comida',
  'confirmar_ordenes': 'Confirmar Órdenes',
  'registrar_productos': 'Registrar Productos',
  'registrar_empleados': 'Empleados',
};
