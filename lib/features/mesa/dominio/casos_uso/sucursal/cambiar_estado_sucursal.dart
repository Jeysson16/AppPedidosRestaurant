import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/sucursal_repositorio.dart';

class CambiarEstadoSucursalCasodeUso {
  final SucursalRepository repository;

  CambiarEstadoSucursalCasodeUso(this.repository);

  Future<void> execute(Sucursal sucursal) {
    return repository.cambiarEstado(sucursal);
  }
}