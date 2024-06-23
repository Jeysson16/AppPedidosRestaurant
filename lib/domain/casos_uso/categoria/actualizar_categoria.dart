import 'package:restaurant_app/domain/entidades/categoria.dart';
import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class ActualizarCategoriaCasodeUso {
  final CategoriaRepository repository;

  ActualizarCategoriaCasodeUso(this.repository);

  Future<void> execute(Categoria categoria) {
    return repository.actualizarCategoria(categoria);
  }
}