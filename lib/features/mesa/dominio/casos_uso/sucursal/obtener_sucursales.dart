import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/sucursal_repositorio.dart';

class ObtenerSucursalesCasodeUso {
  final SucursalRepository repository;

  ObtenerSucursalesCasodeUso(this.repository);

  Future<List<Sucursal>> execute() {
    return repository.obtenerSucursales();
  }
}
