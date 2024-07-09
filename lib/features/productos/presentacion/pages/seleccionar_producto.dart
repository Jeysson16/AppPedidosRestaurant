import 'package:flutter/material.dart';
import 'package:restaurant_app/features/mesa/presentacion/pages/seleccionada_mesa.dart';

class SeleccionarMesaDetallePage extends StatefulWidget {
  final String pisoId;
  final String pisoNombre;
  final String mesaId;
  final String mesaNombre;

  const SeleccionarMesaDetallePage(
      {super.key,
      required this.pisoId,
      required this.pisoNombre,
      required this.mesaId,
      required this.mesaNombre});

  @override
  _SeleccionarMesaDetallePageState createState() =>
      _SeleccionarMesaDetallePageState();
}

class _SeleccionarMesaDetallePageState
    extends State<SeleccionarMesaDetallePage> {
  String? piso;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Mesa'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text('Detalles de la mesa seleccionada:',
                    style: TextStyle(fontSize: 18)),
                const SizedBox(height: 20),
                Text('Piso ID: ${widget.pisoNombre}'),
                const SizedBox(height: 10),
                Text('Mesa ID: ${widget.mesaId}'),
              ],
            ),
          ),
          const ListadoProductos(),
        ],
      ),
    );
  }
}
