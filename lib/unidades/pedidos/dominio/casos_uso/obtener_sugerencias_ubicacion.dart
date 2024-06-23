import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class ObtenerSugerenciasUbicacion {
  final UbicacionRepositorio repository;

  ObtenerSugerenciasUbicacion(this.repository);

  Future<List<String>> call(String query) async {
    return await repository.obtenerSugerencias(query);
  }
}
