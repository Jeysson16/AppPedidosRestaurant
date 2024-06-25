import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';

class CategoriaProductos extends Equatable {
  final String id;
  final String nombre;
  final List<Producto> productos;

  const CategoriaProductos({
    required this.id,
    required this.nombre,
    required this.productos,
  });

  @override
  List<Object?> get props => [id, nombre, productos];
}