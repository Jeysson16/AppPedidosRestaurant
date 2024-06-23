import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class EliminarCategoriaCasodeUso {
  final CategoriaRepository repository;

  EliminarCategoriaCasodeUso(this.repository);

  Future<void> execute(String id) {
    return repository.eliminarCategoria(id);
  }
}
