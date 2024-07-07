import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/producto_repositorio.dart';

class CrearCategoriaCasodeUso {
  final ProductoRepository repository;

  CrearCategoriaCasodeUso(this.repository);

  Future<void> execute(Producto producto) {
    return repository.addProducto(producto);
  }
}
