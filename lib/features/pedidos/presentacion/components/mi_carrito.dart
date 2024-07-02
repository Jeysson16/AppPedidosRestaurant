import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/pedidos_opciones.dart';

class VistaCarrito extends StatelessWidget {
  const VistaCarrito({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PresentacionPedidosBloc>(context);
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
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage(item.producto.imagenPrincipal ?? ''),
                  ),
                  title: Text(item.producto.nombre),
                  subtitle: Text('Cantidad: ${item.cantidad}'),
                  trailing:
                      Text('S/. ${item.producto.precio.toStringAsFixed(2)}'),
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
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const PedidoOptionsScreen()),
              );
            },
            child: const Text('Cómo deseas que sea tu pedido'),
          ),
        ),
      ],
    );
  }
}
