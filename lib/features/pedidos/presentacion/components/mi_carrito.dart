import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/app/global/view/components/my_button_rounded.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/pedidos_opciones.dart';

class VistaCarrito extends StatelessWidget {
  const VistaCarrito({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PresentacionPedidosBloc>(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxHeight < MediaQuery.of(context).size.height * 0.23) {
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
              child: ListView.builder(
                itemCount: bloc.carrito.length,
                itemBuilder: (context, index) {
                  final item = bloc.carrito[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
                          backgroundImage: NetworkImage(item.producto.imagenPrincipal ?? ''),
                        ),
                        const SizedBox(width: 10),
                        Text(item.cantidad.toString(), style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 5),
                        const Text('x', style: TextStyle(color: Colors.white)),
                        const SizedBox(width: 10),
                        Text(item.producto.nombre, style: const TextStyle(color: Colors.white)),
                        const Spacer(),
                        Text('S/. ${item.producto.precio.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white)),
                        const SizedBox(width: 10),
                        IconButton(
                          icon: Icon(Icons.delete, color: Theme.of(context).colorScheme.primary),
                          onPressed: () {
                            bloc.eliminarItem(item.producto);
                          },
                        ),
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
                    'S/. ${bloc.carrito.fold<double>(0.0, (total, item) => total + item.producto.precio * item.cantidad).toStringAsFixed(2)}',
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
                text: '¿Cómo deseas que sea tu pedido?', 
                icono: const Icon(
                  Icons.skip_next,
                  color: Colors.white,
                  size: 24,
                ), 
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PedidoOptionsScreen()),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
