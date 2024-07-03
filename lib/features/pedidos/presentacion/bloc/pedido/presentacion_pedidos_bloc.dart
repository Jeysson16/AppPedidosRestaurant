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

  void addProducto({
    required Producto producto,
    required int cantidad,
    required String observacion,
    required int selectedSizeIndex,
    required int selectedVarianteIndex,
    required List<int> selectedAgregados,
  }) {
    for (PedidoSeleccionadoItem item in carrito) {
      if (item.producto.id == producto.id &&
          item.selectedSizeIndex == selectedSizeIndex &&
          item.selectedVarianteIndex == selectedVarianteIndex &&
          _areAgregadosEqual(item.selectedAgregados, selectedAgregados)) {
        item.add(cantidad);
        notifyListeners();
        return;
      }
    }
    carrito.add(PedidoSeleccionadoItem(
      cantidad: cantidad,
      observacion: observacion,
      producto: producto,
      selectedSizeIndex: selectedSizeIndex,
      selectedVarianteIndex: selectedVarianteIndex,
      selectedAgregados: selectedAgregados,
    ));
    notifyListeners();
  }

  void eliminarItem(Producto producto) {
    carrito.removeWhere((item) => item.producto.id == producto.id);
    notifyListeners();
  }

  int totalCarritoElementos() => carrito.fold<int>(
      0, (previousValue, element) => previousValue + element.cantidad);

  double totalCarritoPrecio() => carrito.fold<double>(
      0.0, (previousValue, element) => previousValue + element.calcularPrecioTotal());

  bool _areAgregadosEqual(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class PedidoSeleccionadoItem {
  int cantidad;
  String observacion;
  final Producto producto;
  final int selectedSizeIndex;
  final int selectedVarianteIndex;
  final List<int> selectedAgregados;

  PedidoSeleccionadoItem({
    required this.cantidad,
    required this.observacion,
    required this.producto,
    required this.selectedSizeIndex,
    required this.selectedVarianteIndex,
    required this.selectedAgregados,
  });

  void add(int amount) {
    cantidad += amount;
  }

  void subtract(int amount) {
    if (cantidad > amount) {
      cantidad -= amount;
    } else {
      cantidad = 0;
    }
  }

  double calcularPrecioTotal() {
    double total = producto.precio * cantidad;

    if (producto.variantes != null && producto.variantes!.isNotEmpty) {
      total += producto.variantes![selectedVarianteIndex].precio * cantidad;
    }

    if (producto.tamanos != null && producto.tamanos!.isNotEmpty) {
      total += producto.tamanos![selectedSizeIndex].precio * cantidad;
    }

    for (int i = 0; i < selectedAgregados.length; i++) {
      total += producto.agregados![i].precio * selectedAgregados[i];
    }

    return total;
  }
}
