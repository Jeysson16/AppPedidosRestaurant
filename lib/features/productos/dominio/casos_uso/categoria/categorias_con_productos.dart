import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';
class ObtenerCategoriasConProductosCasodeUso {
  final CategoriaRepository repository;

  ObtenerCategoriasConProductosCasodeUso(this.repository);

  Future<List<CategoriaConProductos>> execute(String sucursalId) {
    return repository.obtenerCategoriasConProductos(sucursalId);
  }
}
