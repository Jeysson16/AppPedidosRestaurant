import 'package:equatable/equatable.dart';

abstract class PresentacionPedidoEvent extends Equatable {
  const PresentacionPedidoEvent();

  @override
  List<Object> get props => [];
}

class LoadPresentacionPedido extends PresentacionPedidoEvent {}

class ChangeStateToCart extends PresentacionPedidoEvent {}
