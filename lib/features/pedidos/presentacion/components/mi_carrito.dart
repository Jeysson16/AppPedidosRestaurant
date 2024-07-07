import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/pedidos_opciones.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';

class VistaCarrito extends StatelessWidget {
  const VistaCarrito({super.key});

  @override
  Widget build(BuildContext context) {
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
                              backgroundImage: NetworkImage(
                                  item.producto.imagenPrincipal ?? ''),
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
                text: '¿Cómo deseas tu pedido?',
                precio: '',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PedidoOptionsScreen(
                        bloc: bloc,
                        initialAction: SliderAction.None,
                      ),
                    ),
                  );
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
