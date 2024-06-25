import 'package:equatable/equatable.dart';

abstract class ProductosEvent extends Equatable {
  const ProductosEvent();

  @override
  List<Object> get props => [];
}

class LoadProductos extends ProductosEvent {
  final String sucursalId;

  const LoadProductos(this.sucursalId);

  @override
  List<Object> get props => [sucursalId];
}