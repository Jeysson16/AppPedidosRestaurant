
import 'package:restaurant_app/domain/entidades/categoria_productos.dart';
import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class BuscarCategoriasPorNombreCasodeUso {
  final CategoriaRepository repository;

  BuscarCategoriasPorNombreCasodeUso(this.repository);

  Future<List<CategoriaConProductos>> execute(String nombre, String sucursalId) {
    return repository.buscarCategoriasPorNombre(nombre, sucursalId);
  }
}
