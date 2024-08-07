import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:restaurant_app/app/global/view/components/cargando_pagina.dart';
import 'package:restaurant_app/features/menu/view/bloc/menu_bloc_provider.dart';
import 'package:restaurant_app/features/mesa/presentacion/pages/seleccionada_mesa.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/features/menu/data/service/firebase_service_mesa.dart';

class SeleccionarMesaPage extends StatefulWidget {
  static const routeName = '/seleccionar';
  const SeleccionarMesaPage({super.key});

  @override
  _SeleccionarMesaPageState createState() => _SeleccionarMesaPageState();
}

class _SeleccionarMesaPageState extends State<SeleccionarMesaPage> {
  final MesaService _mesaService = MesaService();
  String? _selectedPiso;
  List<DocumentSnapshot> _pisos = [];
  List<DocumentSnapshot> _mesas = [];
  bool _isLoading = true;

  @override
  void initState() {
    PreferenciasUsuario.init(); // Inicializar preferencias antes de usarlas
    PreferenciasUsuario prefs = PreferenciasUsuario();
    super.initState();
    _loadPisos();
  }

  // Método para guardar pisoId y mesaId en PreferenciasUsuario
  Future<void> _guardarSeleccion(String pisoId, String mesaId) async {
    PreferenciasUsuario.init();
    PreferenciasUsuario prefs = PreferenciasUsuario();
    prefs.pisoId = pisoId;
    prefs.mesaId = mesaId;
  }

  Future<void> _loadPisos() async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
    final sucursalId = preferenciasUsuario.sucursalId;
    if (sucursalId != null) {
      try {
        final pisos = await _mesaService.getPisos(sucursalId);
        setState(() {
          _pisos = pisos;
          _isLoading = false;
          if (_pisos.isNotEmpty) {
            _selectedPiso = _pisos.first.id;
            _loadMesas(_selectedPiso!);
          }
        });
      } catch (e) {
        setState(() {
          _isLoading =
              false; // Marca la carga como completada aunque haya error
        });
      }
    } else {
      setState(() {
        _isLoading =
            false; // Marca la carga como completada si no hay sucursalId
      });
    }
  }

  Future<void> _loadMesas(String pisoId) async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
    final sucursalId = preferenciasUsuario.sucursalId;

    if (sucursalId != null) {
      try {
        final mesas = await _mesaService.getMesas(sucursalId, pisoId);
        setState(() {
          _mesas = mesas;
        });
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  Color _getMesaColor(String estado) {
    switch (estado) {
      case 'Disponible':
        return Colors.green;
      case 'Consumiendo':
        return Colors.orange;
      case 'Reservado':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getMesaIcon(String estado) {
    switch (estado) {
      case 'Disponible':
        return Icons.event_seat;
      case 'Consumiendo':
        return Icons.fastfood;
      case 'Reservado':
        return Icons.bookmark;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final menuBloc = MenuBlocProvider.of(context)!.menuBloc;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CustomLoadingPage())
          : ResponsiveBuilder(
              builder: (context, sizingInformation) {
                int crossAxisCount;
                double childAspectRatio;

                if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.desktop) {
                  crossAxisCount = 4;
                  childAspectRatio = 1.5;
                } else if (sizingInformation.deviceScreenType ==
                    DeviceScreenType.tablet) {
                  crossAxisCount = 3;
                  childAspectRatio = 1.5;
                } else {
                  crossAxisCount = 2;
                  childAspectRatio = 1;
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: menuBloc.showSettings,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: _pisos.map((piso) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedPiso = piso.id;
                                    _loadMesas(piso.id);
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: _selectedPiso == piso.id
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context)
                                            .colorScheme
                                            .inverseSurface
                                            .withOpacity(0.3),
                                  ),
                                  child: Text(
                                    piso['descripcion'],
                                    style: TextStyle(
                                      color: _selectedPiso == piso.id
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_mesas.isNotEmpty)
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(10),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: _mesas.length,
                          itemBuilder: (context, index) {
                            final mesa = _mesas[index];
                            return GestureDetector(
                              onTap: () {
                                if (mesa['estado'] == 'Disponible') {
                                  setState(() {});
                                  _guardarSeleccion(_selectedPiso!, mesa.id);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const ListadoProductos()),
                                  );
                                }
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        _getMesaIcon(mesa['estado']),
                                        color: _getMesaColor(mesa['estado']),
                                        size: 48,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Mesa ${mesa['numero']}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: _getMesaColor(mesa['estado']),
                                        ),
                                      ),
                                      Text(
                                        mesa['descripcion'] ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: _getMesaColor(mesa['estado']),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const Text(
                            'Leyenda de estados:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildLegendItem(
                                  'Disponible', Colors.green, Icons.event_seat),
                              _buildLegendItem(
                                  'Consumiendo', Colors.orange, Icons.fastfood),
                              _buildLegendItem(
                                  'Reservado', Colors.red, Icons.bookmark),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 60,
                    )
                  ],
                );
              },
            ),
    );
  }

  Widget _buildLegendItem(String estado, Color color, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(estado),
      ],
    );
  }
}
