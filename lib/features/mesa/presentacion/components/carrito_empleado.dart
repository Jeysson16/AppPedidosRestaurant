import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';
import 'package:restaurant_app/features/auth/data/service/dni_service_repositorio.dart';
import 'package:restaurant_app/features/menu/view/pages/menu.dart';
import 'package:restaurant_app/features/pedidos/data/repositorios/pedido_repostorio.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/pedido.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VistaCarritoEmpleado extends StatelessWidget {
  const VistaCarritoEmpleado({super.key});
  @override
  Widget build(BuildContext context) {
    PreferenciasUsuario.init(); // Inicializar preferencias antes de usarlas
    PreferenciasUsuario prefs = PreferenciasUsuario();
    final pedidoRepository = FirebasePedidoRepository();
    TextEditingController dniController = TextEditingController();
    final bloc = Provider.of<PresentacionPedidosBloc>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < MediaQuery.of(context).size.height * 0.28) {
          return Container();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detalles del Carrito',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: bloc.carrito.length,
                separatorBuilder: (context, index) =>
                    const Divider(color: Colors.grey),
                itemBuilder: (context, index) {
                  final item = bloc.carrito[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                              backgroundImage: item.producto.imagenPrincipal !=
                                      null
                                  ? NetworkImage(item.producto.imagenPrincipal!)
                                  : const AssetImage('assets/restaurant.png'),
                            ),
                            const SizedBox(width: 10),
                            Text(item.cantidad.toString(),
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 5),
                            const Text('x',
                                style: TextStyle(color: Colors.white)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(item.producto.nombre,
                                  style: const TextStyle(color: Colors.white)),
                            ),
                            Text(
                                'S/. ${item.calcularPrecioTotal().toStringAsFixed(2)}',
                                style: const TextStyle(color: Colors.white)),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: Icon(Icons.delete,
                                  color: Theme.of(context).colorScheme.primary),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    context, bloc, item.producto);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (item.selectedTamanoIndex != null &&
                            item.producto.tamanos != null &&
                            item.producto.tamanos!.isNotEmpty &&
                            item.selectedTamanoIndex! <
                                item.producto.tamanos!.length)
                          Text(
                            item.producto.tamanos![item.selectedTamanoIndex!]
                                .nombre,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        if (item.selectedVarianteIndex != null &&
                            item.producto.variantes != null &&
                            item.producto.variantes!.isNotEmpty &&
                            item.selectedVarianteIndex! <
                                item.producto.variantes!.length)
                          Text(
                            item.producto
                                .variantes![item.selectedVarianteIndex!].nombre,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        if (item.selectedAgregados != null &&
                            item.producto.agregados != null &&
                            item.producto.agregados!.isNotEmpty)
                          ...List.generate(item.selectedAgregados!.length, (i) {
                            if (item.selectedAgregados![i] > 0 &&
                                i < item.producto.agregados!.length) {
                              return Text(
                                '${item.producto.agregados![i].nombre} (${item.selectedAgregados![i]})',
                                style: const TextStyle(color: Colors.white70),
                              );
                            }
                            return const SizedBox.shrink();
                          }),
                        const SizedBox(height: 10),
                        ...List.generate(item.observaciones.length, (i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    initialValue: item.observaciones[i],
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText:
                                          'Observación para el chef o mesero',
                                      labelStyle: const TextStyle(
                                          color: Colors.white70),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                    onChanged: (value) {
                                      item.observaciones[i] = value;
                                      Provider.of<PresentacionPedidosBloc>(
                                              context,
                                              listen: false)
                                          .notifyListeners();
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                                  onPressed: () {
                                    _showDeleteObservationDialog(
                                        context, bloc, item, i);
                                  },
                                )
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(color: Colors.white),
            TextFormField(
              style: const TextStyle(color: Colors.white),
              controller: dniController,
              decoration: InputDecoration(
                labelText: 'DNI del Cliente',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'S/. ${bloc.totalCarritoPrecio().toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButtonRounded(
                text: 'Realizar el pedido',
                precio: '',
                onTap: () async {
                  // Obtener los IDs de Sucursal, Piso y Mesa desde SharedPreferences
                  final preferences = await SharedPreferences.getInstance();
                  final idSucursal = preferences.getString('sucursalId') ?? '';
                  final idPiso = preferences.getString('pisoId') ?? '';
                  final idMesa = preferences.getString('mesaId') ?? '';
                  final dni = dniController.text.trim();
                  String descripcion = '';
                  // Obtener datos del DNI
                  if (dni.length == 8) {
                    final dniData = await DniService().fetchDniData(dni);
                    // Construir la descripción del pedido
                    descripcion = 'Cliente con DNI $dni, ';
                    descripcion +=
                        '${dniData.apellidoPaterno} ${dniData.apellidoMaterno}, ${dniData.nombres}';

                    // Calcular detalles del pedido
                    List<DetallePedido> detallesPedido =
                        bloc.carrito.map((item) {
                      final double descuento = (item.producto.promocion ?? 0) *
                          item.cantidad.toDouble(); // Calcular descuento
                      DetallePedido detalle = DetallePedido(
                        cantidad: item.cantidad,
                        producto: item.producto,
                        observaciones: item.observaciones.join(', '),
                        descripcion: item.obtenerDescripcion(),
                        precioUnitario: item.producto.precio,
                        estado: 'Sin Atención',
                        descuento: descuento,
                      );
                      return detalle;
                    }).toList();

                    // Crear el pedido
                    Pedido pedido = Pedido(
                      descripcion: descripcion,
                      precio: bloc.totalCarritoPrecio(),
                      horaInicioServicio: DateTime.now(),
                      esDelivery: false,
                      sucursalId: idSucursal,
                      pisoId: idPiso,
                      mesaId: idMesa,
                      detalles: detallesPedido,
                    );
                    try {
                      await pedidoRepository.actualizarEstado(
                          'Consumiendo', idSucursal, idMesa, idPiso);
                      // Llamar al servicio para enviar el pedido
                      await pedidoRepository.crearPedido(pedido);
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Pedido realizado con éxito'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      // Limpiar el carrito de compras en el bloc
                      bloc.carrito.clear();
                      bloc.changeToNormal(); // Cambiar el estado a normal después de realizar el pedido

                      // Navegar a la pantalla de selección de mesa u otra pantalla según necesidad
                      Navigator.push(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeleccionarMenuApp(),
                        ),
                      );
                    } catch (e) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Error al realizar el pedido. Inténtalo de nuevo.'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Completa el DNI del cliente'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(
      BuildContext context, PresentacionPedidosBloc bloc, Producto producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este producto del carrito?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                bloc.eliminarItem(producto);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteObservationDialog(BuildContext context,
      PresentacionPedidosBloc bloc, dynamic item, int observationIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          title: const Text(
            'Confirmación',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          content: Text(
            '¿Estás seguro de que deseas eliminar este pedido de "${item.producto.nombre}"?',
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eliminar'),
              onPressed: () {
                bloc.eliminarObservacion(item.producto, observationIndex);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
