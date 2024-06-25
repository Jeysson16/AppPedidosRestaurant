import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class BuscarUbicacionManual {
  final UbicacionRepositorio repository;

  BuscarUbicacionManual(this.repository);

  Future<Position> call(String direccion) async {
    return await repository.buscarUbicacionManual(direccion);
  }
}