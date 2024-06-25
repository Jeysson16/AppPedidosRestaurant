import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class GeocodificarDireccion {
  final UbicacionRepositorio repository;

  GeocodificarDireccion(this.repository);

  Future<Position> call(String direccion) async {
    return await repository.geocodificarDireccion(direccion);
  }
}