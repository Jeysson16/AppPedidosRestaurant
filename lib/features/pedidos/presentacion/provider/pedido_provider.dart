import 'package:flutter/material.dart';
import 'package:restaurant_app/features/pedidos/presentacion/bloc/pedido/presentacion_pedidos_bloc.dart';

class PedidosProvider extends InheritedWidget {
  final PresentacionPedidosBloc bloc;
  @override
  final Widget child;

  const PedidosProvider({
    super.key,
    required this.bloc,
    required this.child,
  }) : super(child: child);

  static PedidosProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<PedidosProvider>();

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
