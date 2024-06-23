import 'categoria.dart';
import 'producto.dart';

class CategoriaConProductos {
  final Categoria categoria;
  final List<Producto> productos;

  CategoriaConProductos({
    required this.categoria,
    required this.productos,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoria': categoria.toJson(),
      'productos': productos.map((producto) => producto.toJson()).toList(),
    };
  }
}