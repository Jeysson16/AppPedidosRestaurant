import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class CalcularCobro {
  final UbicacionRepositorio repositorio;

  CalcularCobro(this.repositorio);

  double call(double tiempoMoto) {
    return repositorio.calcularCobro(tiempoMoto);
  }
}