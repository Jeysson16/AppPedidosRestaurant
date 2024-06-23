import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';
import 'package:geolocator/geolocator.dart';

class ObtenerUbicacionTiempoReal {
  final UbicacionRepositorio repositorio;

  ObtenerUbicacionTiempoReal(this.repositorio);

  Future<Position> call() async {
    return await repositorio.obtenerUbicacionTiempoReal();
  }
}