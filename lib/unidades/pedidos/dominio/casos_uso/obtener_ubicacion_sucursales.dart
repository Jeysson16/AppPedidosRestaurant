import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/unidades/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class ObtenerUbicacionesSucursales {
  final UbicacionRepositorio repository;

  ObtenerUbicacionesSucursales(this.repository);

  Future<List<Sucursal>> call() async {
    return await repository.obtenerSucursales();
  }
}
