import 'package:restaurant_app/features/productos/dominio/entidades/categoria.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';

class CrearCategoriaCasodeUso {
  final CategoriaRepository repository;

  CrearCategoriaCasodeUso(this.repository);

  Future<void> execute(Categoria categoria) {
    return repository.crearCategoria(categoria);
  }
}