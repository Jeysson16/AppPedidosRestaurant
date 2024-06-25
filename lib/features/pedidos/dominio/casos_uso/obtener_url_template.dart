import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class ObtenerUrlTemplate {
  final UbicacionRepositorio repository;

  ObtenerUrlTemplate(this.repository);

  String call(String modoTema) {
    return repository.obtenerUrlTemplate(modoTema);
  }
}