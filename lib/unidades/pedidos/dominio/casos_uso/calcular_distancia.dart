import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class CalcularDistancia {
  final UbicacionRepositorio repositorio;

  CalcularDistancia(this.repositorio);

  double call(Position origen, Position destino) {
    return repositorio.calcularDistancia(origen, destino);
  }
}
