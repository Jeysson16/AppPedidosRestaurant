import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/categoria.dart';

class ActualizarCategoriaCasodeUso {
  final CategoriaRepository repository;

  ActualizarCategoriaCasodeUso(this.repository);

  Future<void> execute(Categoria categoria) {
    return repository.actualizarCategoria(categoria);
  }
}