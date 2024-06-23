import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/sucursal_repositorio.dart';

class ObtenerSucursalesCasodeUso {
  final SucursalRepository repository;

  ObtenerSucursalesCasodeUso(this.repository);

  Future<List<Sucursal>> execute() {
    return repository.obtenerSucursales();
  }
}
