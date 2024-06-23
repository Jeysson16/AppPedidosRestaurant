import 'package:restaurant_app/domain/entidades/categoria.dart';
import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class CrearCategoriaCasodeUso {
  final CategoriaRepository repository;

  CrearCategoriaCasodeUso(this.repository);

  Future<void> execute(Categoria categoria) {
    return repository.crearCategoria(categoria);
  }
}