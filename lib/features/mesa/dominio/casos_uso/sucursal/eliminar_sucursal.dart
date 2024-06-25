import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/sucursal_repositorio.dart';

class EliminarSucursalCasodeUso {
  final SucursalRepository repository;

  EliminarSucursalCasodeUso(this.repository);

  Future<void> execute(Sucursal sucursal) {
    return repository.eliminar(sucursal);
  }
}
