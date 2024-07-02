import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:restaurant_app/features/productos/presentacion/widget/detalle_productos.dart';

class SliverBodyItems extends StatelessWidget {
  const SliverBodyItems({
    super.key,
    required this.listItem,
  });

  final List<Producto> listItem;

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<PresentacionPedidosBloc>(context, listen: false);
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = listItem[index];
          final imageProvider = product.imagenPrincipal != null
              ? NetworkImage(product.imagenPrincipal!)
              : const AssetImage('assets/restaurant.png') as ImageProvider;

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ProductosDetalles(
                    product: product,
                    imageProvider: imageProvider,
                    onProductoAgregado: () {
                      bloc.addProducto(product);
                    },
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.nombre,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  product.descripcion,
                                  maxLines: 4,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'S/. ${product.precio.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'list_${product.id}',
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
                            height: 140,
                            width: 130,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index == listItem.length - 1) ...[
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 0.5,
                        color: Theme.of(context)
                            .colorScheme
                            .inversePrimary
                            .withOpacity(0.3),
                      ),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
        childCount: listItem.length,
      ),
    );
  }
}
