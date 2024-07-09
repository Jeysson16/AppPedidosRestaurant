import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';
import 'package:uuid/uuid.dart';

class ItemsCarrusel extends StatelessWidget {
  const ItemsCarrusel({
    super.key,
    required double percent,
    required this.itemsCarrito,
    required int index,
  })  : _percent = percent,
        _index = index;

  final double _percent;
  final List<PedidoSeleccionadoItem> itemsCarrito;
  final int _index;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return Stack(
          alignment: Alignment.center,
          children: [
            // tercero
            if (_index > 1 && _index < itemsCarrito.length)
              _ItemsTransforms(
                item: itemsCarrito[_index - 2],
                scale: lerpDouble(.3, 0, _percent)!,
                opacity: lerpDouble(0.5, 0.0, _percent)!,
              ),

            // segundo
            if (_index > 0 && _index < itemsCarrito.length)
              _ItemsTransforms(
                item: itemsCarrito[_index - 1],
                displacement: lerpDouble((height * .1), 0, _percent)!,
                scale: lerpDouble(.6, .3, _percent)!,
                opacity: lerpDouble(0.8, 0.5, _percent)!,
              ),

            // primero
            if (_index >= 0 && _index < itemsCarrito.length)
              _ItemsTransforms(
                item: itemsCarrito[_index],
                displacement:
                    lerpDouble((height * .25), (height * .1), _percent)!,
                scale: lerpDouble(1.0, .6, _percent)!,
                opacity: lerpDouble(1.0, 0.8, _percent)!,
              ),

            // debajo
            if (_index < itemsCarrito.length - 1)
              _ItemsTransforms(
                item: itemsCarrito[_index + 1],
                displacement: lerpDouble(height, (height * .25), _percent)!,
                scale: lerpDouble(2.0, 1.0, _percent)!,
              ),
          ],
        );
      },
    );
  }
}

class _ItemsTransforms extends StatelessWidget {
  const _ItemsTransforms(
      {required this.item,
      this.displacement = 0.0,
      this.scale = 1.0,
      this.opacity = 1.0});

  final double displacement;
  final double scale;
  final double opacity;
  final PedidoSeleccionadoItem item;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, displacement),
      child: Transform.scale(
        alignment: Alignment.topCenter,
        scale: scale,
        child: Stack(
          children: [
            Opacity(
              opacity: opacity,
              child: _ItemImagen(
                item: item,
              ),
            ),
            Positioned(
              top: 8.0, // Ajusta la posición vertical del botón
              right: 8.0, // Ajusta la posición horizontal del botón
              child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 1.0, end: 0.0),
                curve: Curves.fastOutSlowIn,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: Offset((scale * .3) * value, 0),
                    child: Transform.rotate(
                      angle: 4.28 * value,
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemImagen extends StatelessWidget {
  const _ItemImagen({
    required this.item,
  });
  final PedidoSeleccionadoItem item;

  @override
  Widget build(BuildContext context) {
    const uuid = Uuid();
    return Align(
      alignment: Alignment.topCenter,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(200),
        child: AspectRatio(
          aspectRatio: 0.95,
          child: Hero(
            tag: uuid.v4(),
            child: Image.network(
              item.producto.imagenPrincipal ?? '',
              width: double.infinity,
              height: 80,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
