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
    required List<String> observacion,
    required int? selectedTamanoIndex,
    required int? selectedVarianteIndex,
    required List<int>? selectedAgregados,
  }) {
    for (PedidoSeleccionadoItem item in carrito) {
      if (item.producto.id == producto.id &&
          item.selectedTamanoIndex == selectedTamanoIndex &&
          item.selectedVarianteIndex == selectedVarianteIndex &&
          _areAgregadosEqual(item.selectedAgregados, selectedAgregados)) {
        item.add(cantidad);
        notifyListeners();
        return;
      }
    }
    carrito.add(PedidoSeleccionadoItem(
      cantidad: cantidad,
      observaciones: observacion,
      producto: producto,
      selectedTamanoIndex: selectedTamanoIndex,
      selectedVarianteIndex: selectedVarianteIndex,
      selectedAgregados: selectedAgregados,
    ));
    notifyListeners();
  }

  void eliminarItem(Producto producto) {
    carrito.removeWhere((item) => item.producto.id == producto.id);
    notifyListeners();
  }

  void eliminarObservacion(Producto producto, int observacionIndex) {
    for (PedidoSeleccionadoItem item in carrito) {
      if (item.producto.id == producto.id) {
        item.observaciones.removeAt(observacionIndex);
        if (item.observaciones.isEmpty) {
          carrito.remove(item);
        } else {
          item.cantidad--;
        }
        notifyListeners();
        return;
      }
    }
  }

  int totalCarritoElementos() => carrito.fold<int>(
      0, (previousValue, element) => previousValue + element.cantidad);

  double totalCarritoPrecio() => carrito.fold<double>(
      0.0,
      (previousValue, element) =>
          previousValue + element.calcularPrecioTotal());

  bool _areAgregadosEqual(List<int>? a, List<int>? b) {
    if (a == null || b == null) return a == b;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

class PedidoSeleccionadoItem {
  int cantidad;
  List<String> observaciones;
  final Producto producto;
  int? selectedTamanoIndex;
  int? selectedVarianteIndex;
  List<int>? selectedAgregados;

  PedidoSeleccionadoItem({
    required this.cantidad,
    required this.producto,
    this.selectedTamanoIndex,
    this.selectedVarianteIndex,
    this.selectedAgregados,
    List<String>? observaciones,
  }) : observaciones = observaciones ?? List.filled(cantidad, '');

  void add(int amount) {
    cantidad += amount;
    observaciones.addAll(List.filled(amount, ''));
  }

  void subtract(int amount) {
    if (cantidad > amount) {
      cantidad -= amount;
      observaciones = observaciones.sublist(0, cantidad);
    } else {
      cantidad = 0;
      observaciones.clear();
    }
  }

  double calcularPrecioTotal() {
    double total = producto.precio * cantidad;

    if (selectedVarianteIndex != null &&
        producto.variantes != null &&
        producto.variantes!.isNotEmpty) {
      total += producto.variantes![selectedVarianteIndex!].precio * cantidad;
    }

    if (selectedTamanoIndex != null &&
        producto.tamanos != null &&
        producto.tamanos!.isNotEmpty) {
      total += producto.tamanos![selectedTamanoIndex!].precio * cantidad;
    }

    if (selectedAgregados != null) {
      for (int i = 0; i < selectedAgregados!.length; i++) {
        total += producto.agregados![i].precio * selectedAgregados![i];
      }
    }
    // Aplicar promoción si existe
    if (producto.promocion != null && producto.promocion! > 0) {
      total -= producto.promocion! * cantidad;
    }

    return total;
  }

  String obtenerDescripcion() {
    String descripcion = producto.nombre;
    if (selectedTamanoIndex != null &&
        producto.tamanos != null &&
        producto.tamanos!.isNotEmpty) {
      descripcion += " - ${producto.tamanos![selectedTamanoIndex!].nombre}";
    }
    if (selectedVarianteIndex != null &&
        producto.variantes != null &&
        producto.variantes!.isNotEmpty) {
      descripcion += " - ${producto.variantes![selectedVarianteIndex!].nombre}";
    }
    if (selectedAgregados != null &&
        producto.agregados != null &&
        producto.agregados!.isNotEmpty) {
      for (int i = 0; i < selectedAgregados!.length; i++) {
        if (selectedAgregados![i] > 0) {
          descripcion +=
              " - ${selectedAgregados![i]} x ${producto.agregados![i].nombre}";
        }
      }
    }
    return descripcion;
  }
}
