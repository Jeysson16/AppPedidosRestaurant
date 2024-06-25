import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';

class CategoriaProductosModel extends CategoriaProductos {
  const CategoriaProductosModel({
    required super.id,
    required super.nombre,
    required super.productos,
  });

  factory CategoriaProductosModel.fromJson(Map<String, dynamic> json) {
    return CategoriaProductosModel(
      id: json['id'],
      nombre: json['nombre'],
      productos: (json['productos'] as List)
          .map((e) => Producto.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'productos': productos.map((e) => (e).toJson()).toList(),
    };
  }
}
