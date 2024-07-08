import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/presentacion/animation/confirmacion_animacion.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/confirmar_painter.dart';
import 'package:restaurant_app/features/pedidos/presentacion/pages/inicio_pagina.dart';

class FaceIDView extends StatefulWidget {
  const FaceIDView({super.key});

  @override
  State<FaceIDView> createState() => _FaceIDView();
}

class _FaceIDView extends State<FaceIDView>
    with SingleTickerProviderStateMixin {
  late final FaceIDAnimationController _faceIDAnimationController;

  @override
  void initState() {
    _faceIDAnimationController = FaceIDAnimationController(
      animationController: AnimationController(
        duration: const Duration(seconds: 4),
        vsync: this,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _faceIDAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const InicioPagina()))
      },
      child: Scaffold(
        body: Center(
          child: CustomPaint(
            size: const Size(200, 200),
            painter: FaceIDPainter(
              controller: _faceIDAnimationController..fordward(),
            ),
          ),
        ),
      ),
    );
  }
}
