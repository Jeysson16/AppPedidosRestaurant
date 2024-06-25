import 'package:restaurant_app/features/productos/dominio/entidades/categoria.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';

class ObtenerTodasLasCategoriasCasodeUso {
  final CategoriaRepository repository;

  ObtenerTodasLasCategoriasCasodeUso(this.repository);

  Future<List<Categoria>> execute(String sucursalId) {
    return repository.obtenerTodasLasCategorias(sucursalId);
  }
}