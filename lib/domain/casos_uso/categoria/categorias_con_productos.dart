import 'package:restaurant_app/domain/entidades/categoria_productos.dart';
import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class ObtenerCategoriasConProductosCasodeUso {
  final CategoriaRepository repository;

  ObtenerCategoriasConProductosCasodeUso(this.repository);

  Future<List<CategoriaConProductos>> execute(String sucursalId) {
    return repository.obtenerCategoriasConProductos(sucursalId);
  }
}
