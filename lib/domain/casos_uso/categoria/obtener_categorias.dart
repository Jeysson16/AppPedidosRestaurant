import 'package:restaurant_app/domain/entidades/categoria.dart';
import 'package:restaurant_app/domain/repositorios/categoria_repositorio.dart';

class ObtenerTodasLasCategoriasCasodeUso {
  final CategoriaRepository repository;

  ObtenerTodasLasCategoriasCasodeUso(this.repository);

  Future<List<Categoria>> execute(String sucursalId) {
    return repository.obtenerTodasLasCategorias(sucursalId);
  }
}