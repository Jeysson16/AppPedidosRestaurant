import 'package:restaurant_app/features/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/autenticacion/dominio/repositorios/sucursal_repositorio.dart';

class BuscarSucursalPorIdCasodeUso {
  final SucursalRepository repository;

  BuscarSucursalPorIdCasodeUso(this.repository);

  Future<Sucursal> execute(String id) {
    return repository.buscarSucursalPorId(id);
  }
}
