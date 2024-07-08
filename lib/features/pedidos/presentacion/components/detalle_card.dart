import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:uuid/uuid.dart';

class SuperheroCard extends StatelessWidget {
  const SuperheroCard({
    super.key,
    required this.detallePedido,
    required this.factorChange,
  });

  final DetallePedido detallePedido;
  final double? factorChange;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final separation = size.height * .24;
    return OverflowBox(
      alignment: Alignment.topCenter,
      maxHeight: size.height,
      child: Stack(
        children: [
          //--------------------------------------------
          // Color bg with rounded corners
          //--------------------------------------------
          Positioned.fill(
            top: separation,
            child: Hero(
              tag: '${detallePedido.descripcion}background',
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: detallePedido.color,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
            ),
          ),
          //-----------------------------------
          // Superhero image
          //-----------------------------------
          Positioned(
            left: 20,
            right: 20,
            top: separation * factorChange!,
            bottom: size.height * 0.5,
            child: Opacity(
              opacity: 1.0 - factorChange!,
              child: Transform.scale(
                scale: lerpDouble(1, .4, factorChange!),
                child: Hero(
                  tag: const Uuid(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                        20), // Aquí puedes ajustar el radio de borde
                    child: Image.network(
                      detallePedido.producto.imagenPrincipal!,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 40,
            right: 100,
            top: size.height * .5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //----------------------------------
                // Superhero Name
                //----------------------------------
                const SizedBox(height: 25),
                FittedBox(
                  child: Hero(
                    tag: const Uuid(),
                    child: Text(
                      detallePedido.producto.nombre,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //----------------------------------
                // Superhero Secret Identity Name
                //----------------------------------
                Hero(
                  tag: const Uuid(),
                  child: Text(
                    detallePedido.descripcion,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontSize: 20,
                        ),
                  ),
                ),
                const SizedBox(height: 25),
                if (detallePedido.observaciones != null &&
                    detallePedido.observaciones!.isNotEmpty)
                  Hero(
                    tag: const Uuid(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observaciones: ',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                        ),
                        Text(
                          '${detallePedido.observaciones![0].toUpperCase()}${detallePedido.observaciones!.substring(1)}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                color: Colors.black,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                  )
                else
                  SizedBox.shrink(),

                SizedBox(height: 25),
              ],
            ),
          )
        ],
      ),
    );
  }
}
