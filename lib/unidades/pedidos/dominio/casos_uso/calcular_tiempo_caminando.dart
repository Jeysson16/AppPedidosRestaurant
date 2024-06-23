import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';
class CalcularTiempoCaminando {
  final UbicacionRepositorio repositorio;

  CalcularTiempoCaminando(this.repositorio);

  double call(double distancia) {
    return repositorio.calcularTiempoCaminando(distancia);
  }
}