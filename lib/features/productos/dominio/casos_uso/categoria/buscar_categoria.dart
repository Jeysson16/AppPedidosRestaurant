import 'package:restaurant_app/features/productos/dominio/entidades/categoria.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';

class ObtenerCategoriaPorIdUseCase {
  final CategoriaRepository repository;

  ObtenerCategoriaPorIdUseCase(this.repository);

  Future<Categoria> execute(String id) {
    return repository.buscarCategoriaPorId(id);
  }
}
