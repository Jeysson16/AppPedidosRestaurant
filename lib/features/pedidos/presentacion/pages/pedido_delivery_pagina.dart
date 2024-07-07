import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_direccion.dart';

class PedidoDeliveryPagina extends StatefulWidget {
  const PedidoDeliveryPagina({super.key});

  @override
  State<PedidoDeliveryPagina> createState() => _PedidoDeliveryPaginaState();
}

class _PedidoDeliveryPaginaState extends State<PedidoDeliveryPagina> {
  @override
  Widget build(BuildContext context) {
    return const MiUbicacion();
  }
}
