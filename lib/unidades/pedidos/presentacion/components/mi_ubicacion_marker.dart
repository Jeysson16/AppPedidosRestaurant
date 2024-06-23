import 'package:flutter/material.dart';
const markerColor = Color(0xFFED1113);

class MiUbicacionMarker extends StatelessWidget {
  const MiUbicacionMarker({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: markerColor,
        shape: BoxShape.circle,
      ),
    );
  }
}