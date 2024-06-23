import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/sucursal_repositorio.dart';
class ActualizarSucursalCasodeUso {
  final SucursalRepository repository;

  ActualizarSucursalCasodeUso(this.repository);

  Future<void> execute(Sucursal sucursal) {
    return repository.actualizar(sucursal);
  }
}
