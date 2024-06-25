import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';

abstract class ProductosState extends Equatable {
  const ProductosState();

  @override
  List<Object> get props => [];
}

class ProductosInitial extends ProductosState {}

class ProductosLoading extends ProductosState {}

class ProductosLoaded extends ProductosState {
  final List<CategoriaProductos> categoriasConProductos;

  const ProductosLoaded(this.categoriasConProductos);

  @override
  List<Object> get props => [categoriasConProductos];
}

class ProductosError extends ProductosState {
  final String message;

  const ProductosError(this.message);

  @override
  List<Object> get props => [message];
}