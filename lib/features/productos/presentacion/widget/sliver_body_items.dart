import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';

class SliverBodyItems extends StatelessWidget {
  const SliverBodyItems({
    super.key,
    required this.listItem,
  });

  final List<Producto> listItem;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = listItem[index];
          return Padding(
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
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              product.imagenPrincipal ?? 'assets/restaurant.png',
                            ),
                          ),
                        ),
                        height: 140,
                        width: 130,
                      )
                    ],
                  ),
                ),
                if (index == listItem.length - 1) ...[
                  const SizedBox(height: 32),
                  Container(
                    height: 0.5,
                    color: Colors.white.withOpacity(0.3),
                  )
                ]
              ],
            ),
          );
        },
        childCount: listItem.length,
      ),
    );
  }
}
