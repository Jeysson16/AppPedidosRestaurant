import 'package:restaurant_app/features/pedidos/data/model/calle_sugerencias.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class ObtenerSugerenciasUbicacion {
  final UbicacionRepositorio repository;

  ObtenerSugerenciasUbicacion(this.repository);

  Future<List<AddressSuggestion>> call(String query) async {
    return await repository.obtenerSugerencias(query);
  }
}
