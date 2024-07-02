import 'package:flutter/material.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';

enum PresentacionPedidoState {
  normal,
  details,
  cart,
}

class PresentacionPedidosBloc with ChangeNotifier {
  PresentacionPedidoState presentacionState = PresentacionPedidoState.normal;
  List<PedidoSeleccionadoItem> carrito = [];

  void changeToNormal() {
    presentacionState = PresentacionPedidoState.normal;
    notifyListeners();
  }

  void changeToCart() {
    presentacionState = PresentacionPedidoState.cart;
    notifyListeners();
  }

  void changeToDetails() {
    presentacionState = PresentacionPedidoState.details;
    notifyListeners();
  }

  void addProducto(Producto producto) {
    for (PedidoSeleccionadoItem item in carrito) {
      if (item.producto.id == producto.id) {
        item.add();
        notifyListeners();
        return;
      }
    }
    carrito.add(PedidoSeleccionadoItem(
        cantidad: 1, observacion: '', producto: producto));
    notifyListeners();
  }

  int totalCarritoElementos() => carrito.fold<int>(
      0, (previousValue, element) => previousValue + element.cantidad);
}

class PedidoSeleccionadoItem {
  int cantidad;
  String observacion;
  final Producto producto;

  PedidoSeleccionadoItem({
    required this.cantidad,
    required this.observacion,
    required this.producto,
  });

  void add() {
    cantidad++;
  }

  void subtract() {
    if (cantidad > 1) cantidad--;
  }
}
