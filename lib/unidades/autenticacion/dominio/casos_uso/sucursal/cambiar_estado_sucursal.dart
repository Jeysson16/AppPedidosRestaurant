import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/sucursal_repositorio.dart';

class CambiarEstadoSucursalCasodeUso {
  final SucursalRepository repository;

  CambiarEstadoSucursalCasodeUso(this.repository);

  Future<void> execute(Sucursal sucursal) {
    return repository.cambiarEstado(sucursal);
  }
}