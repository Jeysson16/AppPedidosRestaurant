import 'package:restaurant_app/domain/entidades/categoria.dart';
import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class ObtenerCategoriaPorIdUseCase {
  final CategoriaRepository repository;

  ObtenerCategoriaPorIdUseCase(this.repository);

  Future<Categoria> execute(String id) {
    return repository.buscarCategoriaPorId(id);
  }
}
