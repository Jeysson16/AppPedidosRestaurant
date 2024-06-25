import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class GeocodificarCoordenadas {
  final UbicacionRepositorio repository;

  GeocodificarCoordenadas(this.repository);

  Future<Position> call(double latitude, double longitude) async {
    return await repository.geocodificarCoordenadas(latitude, longitude);
  }
}
