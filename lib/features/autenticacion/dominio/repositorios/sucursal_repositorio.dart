import 'package:restaurant_app/features/autenticacion/dominio/entidades/sucursal.dart';

abstract class SucursalRepository {
  Future<Sucursal> buscarSucursalPorId(String id);
  Future<List<Sucursal>> obtenerSucursales();
  Future<void> crear(Sucursal sucursal);
  Future<void> actualizar(Sucursal sucursal);
  Future<void> cambiarEstado(Sucursal sucursal);
  Future<void> eliminar(Sucursal sucursal);
}
