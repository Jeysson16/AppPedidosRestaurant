import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/app/global/view/components/cargando_pagina.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/detalle_card.dart';

class SuperheroSliderPage extends StatefulWidget {
  const SuperheroSliderPage({
    super.key,
  });

  @override
  SuperheroSliderPageState createState() => SuperheroSliderPageState();
}

class SuperheroSliderPageState extends State<SuperheroSliderPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DetallePedido> _detallePedidos = [];

  Future<void> _fetchDetallePedidos() async {
    try {
      // Fetch all pedido documents
      QuerySnapshot pedidosSnapshot =
          await _firestore.collection('pedidos').get();

      List<DetallePedido> detallePedidos = [];
      // For each pedido document, fetch its detallesPedido subcollection
      for (var pedidoDoc in pedidosSnapshot.docs) {
        QuerySnapshot detallesSnapshot =
            await pedidoDoc.reference.collection('detallesPedido').get();

        List<DetallePedido> detalles = detallesSnapshot.docs.map((doc) {
          return DetallePedido.fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
        detallePedidos.addAll(detalles);
      }

      // Update the state with the combined list of detallePedidos
      setState(() {
        _detallePedidos = detallePedidos
            .where((detalle) => detalle.estado == 'Sin Atención')
            .toList();
      });
    } catch (e) {
      print('Error al obtener detalles de pedidos: $e');
    }
  }

  PageController? _pageController;
  late int _index;
  late int _auxIndex;
  double? _percent;
  double? _auxPercent;
  late bool _isScrolling;

  @override
  void initState() {
    super.initState();
    _fetchDetallePedidos();
    _pageController = PageController();
    _index = 0;
    _auxIndex = _index + 1;
    _percent = 0.0;
    _auxPercent = 1.0 - _percent!;
    _isScrolling = false;
    _pageController!.addListener(_pageListener);
  }

  @override
  void dispose() {
    _pageController!
      ..removeListener(_pageListener)
      ..dispose();
    super.dispose();
  }

  //--------------------------
  // Page View Listener
  //--------------------------
  void _pageListener() {
    _index = _pageController!.page!.floor();
    _auxIndex = _index + 1;
    _percent = (_pageController!.page! - _index).abs();
    _auxPercent = 1.0 - _percent!;

    _isScrolling = _pageController!.page! % 1.0 != 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    const angleRotate = -pi * .5;
    return Scaffold(
      body: Stack(
        children: [
          //-----------------------
          // Superhero Cards
          //-----------------------
          AnimatedPositioned(
            duration: kThemeAnimationDuration,
            top: 80,
            bottom: 0,
            right: _isScrolling ? 10 : 0,
            left: _isScrolling ? 10 : 0,
            child: Stack(
              children: [
                //----------------
                // Back Card
                //----------------
                if (_detallePedidos.isNotEmpty) // Ensure the list is not empty
                  Transform.translate(
                    offset: Offset(0, 50 * (_auxPercent ?? 0)),
                    child: SuperheroCard(
                      detallePedido: _detallePedidos[
                          _auxIndex.clamp(0, _detallePedidos.length - 1)],
                      factorChange: _auxPercent,
                    ),
                  ),
                //----------------
                // Front Card
                //----------------
                Transform.translate(
                  offset: Offset(-800 * (_percent ?? 0), 100 * (_percent ?? 0)),
                  child: Transform.rotate(
                    angle: angleRotate * (_percent ?? 0),
                    child: _detallePedidos.isNotEmpty &&
                            _index >= 0 &&
                            _index < _detallePedidos.length
                        ? SuperheroCard(
                            detallePedido: _detallePedidos[_index],
                            factorChange: _percent,
                          )
                        : Container(), // Or any placeholder widget when conditions aren't met
                  ),
                ),
              ],
            ),
          ),
          //-----------------------------------------------------
          // VOID PAGE VIEW
          // This page view is just for using the page controller
          //-----------------------------------------------------
          PageView.builder(
            controller: _pageController,
            itemCount: _detallePedidos.length,
            itemBuilder: (context, index) {
              return InkWell(
                onLongPress: () => _openDetail(context, _detallePedidos[index]),
                child: const SizedBox(),
              );
            },
          )
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, DetallePedido detallePedido) async {
    try {
      // Realizar una consulta para encontrar el detallePedido dentro de la colección 'pedidos'
      QuerySnapshot pedidosSnapshot =
          await _firestore.collection('pedidos').get();

      // Iterar sobre los documentos de pedidos
      for (var pedidoDoc in pedidosSnapshot.docs) {
        // Obtener la referencia a la colección de detallesPedido dentro de cada pedido
        QuerySnapshot detallesSnapshot = await pedidoDoc.reference
            .collection('detallesPedido')
            .where('id', isEqualTo: detallePedido.id)
            .limit(1)
            .get();

        // Verificar si se encontró el detallePedido dentro de este pedido
        if (detallesSnapshot.docs.isNotEmpty) {
          // Obtener la referencia al documento del detallePedido encontrado
          DocumentReference detalleRef = detallesSnapshot.docs.first.reference;

          // Actualizar el estado del detalle pedido a 'Preparado'
          await detalleRef.update({'estado': 'Preparado'});

          // Refrescar la lista _detallePedidos después de la actualización
          await _fetchDetallePedidos();

          // Mostrar mensaje de éxito
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Detalle pedido marcado como preparado')),
          );

          // Salir del bucle si se encontró y actualizó el detallePedido
          return;
        }
      }

      // Mostrar mensaje si no se encontró el detallePedido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se encontró el detalle pedido para actualizar'),
        ),
      );
    } catch (e) {
      // Mostrar mensaje de error si hubo algún problema
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al marcar detalle como preparado')),
      );
    }
  }
}
