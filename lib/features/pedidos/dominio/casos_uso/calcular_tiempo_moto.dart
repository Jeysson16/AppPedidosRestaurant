import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';
class CalcularTiempoMoto {
  final UbicacionRepositorio repositorio;

  CalcularTiempoMoto(this.repositorio);

  double call(double distancia) {
    return repositorio.calcularTiempoMoto(distancia);
  }
}