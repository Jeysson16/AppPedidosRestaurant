import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_direccion.dart';
import 'package:restaurant_app/app/global/view/components/my_drawer.dart';
import 'package:restaurant_app/app/global/view/components/my_sliver_app_bar.dart';
import 'package:restaurant_app/features/pedidos/presentacion/components/mi_info_pedido.dart';

class InicioPagina extends StatefulWidget {
  const InicioPagina({super.key});

  @override
  State<InicioPagina> createState() => _InicioPaginaState();
}

class _InicioPaginaState extends State<InicioPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
        const MySliverAppBar(
          title: Text("Hello"),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              //Descripcion
              //Ubicacion
              MiInfoPedido(),
            ],
          ),
        ),
      ],
      body: Container(
        color: Theme.of(context).colorScheme.error,
        height: 400,
        child: const MiUbicacion(),
      )
    ),
    );
  }
}