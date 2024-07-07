import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
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
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ProductosDetalles(
                        product: product,
                        imageProvider: imageProvider,
                        onProductoAgregado: (selecciones) {
                          for (var seleccion in selecciones) {
                            bloc.addProducto(
                              producto: product,
                              observacion: [
                                seleccion.observacion
                              ], // Convertir a lista
                              cantidad: seleccion.cantidad,
                              selectedTamanoIndex:
                                  seleccion.selectedTamanoIndex,
                              selectedVarianteIndex:
                                  seleccion.selectedVarianteIndex,
                              selectedAgregados: seleccion.selectedAgregados,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              );
            },
            onLongPress: () {
              _showImageGallery(context, product.galeria!);
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
                                Row(
                                  children: [
                                    Text(
                                      'S/. ${product.precio.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    if (product.promocion! > 0)
                                      AnimatedSwitcher(
                                        duration:
                                            const Duration(milliseconds: 300),
                                        transitionBuilder: (Widget child,
                                            Animation<double> animation) {
                                          return ScaleTransition(
                                              scale: animation, child: child);
                                        },
                                        child: Row(
                                          key: ValueKey<double>(
                                              product.promocion!),
                                          children: [
                                            Text(
                                              ' -${product.promocion!.toStringAsFixed(2)}%',
                                              style: TextStyle(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        Hero(
                          tag: 'list_${product.id}_$index',
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
                        )
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

  void _showImageGallery(BuildContext context, List<String> images) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      pauseAutoPlayOnTouch: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 400),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      viewportFraction: 1.0,
                      height: MediaQuery.of(context).size.height * 0.5,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    ),
                    items: images.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return InteractiveViewer(
                            panEnabled: true,
                            boundaryMargin: const EdgeInsets.all(20),
                            minScale: 0.5,
                            maxScale: 4.0,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(image),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
