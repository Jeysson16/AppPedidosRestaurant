import 'package:flutter/material.dart';

enum PresentacionPedidoState {
  normal,
  details,
  cart,
}

class PresentacionPedidosBloc with ChangeNotifier {
  PresentacionPedidoState presentacionState = PresentacionPedidoState.normal;

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
}