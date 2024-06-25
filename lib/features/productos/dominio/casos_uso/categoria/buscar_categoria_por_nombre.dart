import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';

class BuscarCategoriasPorNombreCasodeUso {
  final CategoriaRepository repository;

  BuscarCategoriasPorNombreCasodeUso(this.repository);

  Future<List<CategoriaProductos>> execute(String nombre, String sucursalId) {
    return repository.buscarCategoriasPorNombre(nombre, sucursalId);
  }
}
