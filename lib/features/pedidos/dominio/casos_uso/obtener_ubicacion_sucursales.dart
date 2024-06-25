import 'package:restaurant_app/features/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class ObtenerUbicacionesSucursales {
  final UbicacionRepositorio repository;

  ObtenerUbicacionesSucursales(this.repository);

  Future<List<Sucursal>> call() async {
    return await repository.obtenerSucursales();
  }
}
