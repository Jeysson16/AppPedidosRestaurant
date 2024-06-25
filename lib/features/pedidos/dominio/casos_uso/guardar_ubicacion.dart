import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class GuardarUbicacion {
  final UbicacionRepositorio repository;

  GuardarUbicacion(this.repository);

  Future<void> call(Position ubicacion) async {
    return await repository.guardarUbicacion(ubicacion);
  }
}