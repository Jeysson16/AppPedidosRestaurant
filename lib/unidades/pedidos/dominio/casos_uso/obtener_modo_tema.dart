import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class ObtenerModoTema {
  final UbicacionRepositorio repository;

  ObtenerModoTema(this.repository);

  Future<String> call() async {
    return await repository.obtenerModoTema();
  }
}