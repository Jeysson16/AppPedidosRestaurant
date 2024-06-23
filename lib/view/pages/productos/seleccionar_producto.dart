import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';

class SeleccionarMesaDetallePage extends StatefulWidget {
  final String pisoId;
  final String pisoNombre;
  final String mesaId;
  final String mesaNombre;

  const SeleccionarMesaDetallePage(
      {super.key, required this.pisoId,
      required this.pisoNombre,
      required this.mesaId,
      required this.mesaNombre});

  @override
  _SeleccionarMesaDetallePageState createState() =>
      _SeleccionarMesaDetallePageState();
}

class _SeleccionarMesaDetallePageState
    extends State<SeleccionarMesaDetallePage> {
  List<DocumentSnapshot> _categorias = [];
  final Map<String, List<DocumentSnapshot>> _productosPorCategoria = {};
  final Map<String, int> _carrito = {};
  String? piso;
  @override
  void initState() {
    super.initState();
    _loadCategorias();
  }

  Future<void> _loadCategorias() async {
    PreferenciasUsuario preferenciasUsuario = PreferenciasUsuario();
    try {
      QuerySnapshot categoriasSnapshot = await FirebaseFirestore.instance
          .collection('sucursal')
          .doc(preferenciasUsuario.sucursalId)
          .collection('categoria')
          .get();

      setState(() {
        _categorias = categoriasSnapshot.docs;
      });

      for (var categoria in _categorias) {
        QuerySnapshot productosSnapshot = await FirebaseFirestore.instance
            .collection('sucursal')
            .doc('sucursalid')
            .collection('categoria')
            .doc(categoria.id)
            .collection('producto')
            .get();

        setState(() {
          _productosPorCategoria[categoria.id] = productosSnapshot.docs;
        });
      }
    } catch (e) {
      print('Error al cargar categorías y productos: $e');
    }
  }

  void _addToCart(String productId) {
    setState(() {
      if (_carrito.containsKey(productId)) {
        _carrito[productId] = _carrito[productId]! + 1;
      } else {
        _carrito[productId] = 1;
      }
    });
  }

  void _removeFromCart(String productId) {
    setState(() {
      if (_carrito.containsKey(productId)) {
        if (_carrito[productId]! > 1) {
          _carrito[productId] = _carrito[productId]! - 1;
        } else {
          _carrito.remove(productId);
        }
      }
    });
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
          Expanded(
            child: _categorias.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _categorias.length,
                    itemBuilder: (context, index) {
                      var categoria = _categorias[index];
                      var productos = _productosPorCategoria[categoria.id];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              categoria['nombre'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: productos?.length ?? 0,
                            itemBuilder: (context, index) {
                              var producto = productos![index];
                              return ListTile(
                                title: Text(producto['nombre']),
                                subtitle: Text('Precio: ${producto['precio']}'),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () =>
                                          _removeFromCart(producto.id),
                                    ),
                                    Text(_carrito[producto.id]?.toString() ??
                                        '0'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () => _addToCart(producto.id),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Aquí puedes agregar la lógica para finalizar el pedido
                print('Carrito: $_carrito');
              },
              child: const Text('Finalizar Pedido'),
            ),
          ),
        ],
      ),
    );
  }
}
