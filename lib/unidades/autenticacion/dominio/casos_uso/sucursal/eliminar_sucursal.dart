import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/sucursal_repositorio.dart';

class EliminarSucursalCasodeUso {
  final SucursalRepository repository;

  EliminarSucursalCasodeUso(this.repository);

  Future<void> execute(Sucursal sucursal) {
    return repository.eliminar(sucursal);
  }
}
