import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/piso.dart';

abstract class SucursalRepository {
  Future<List<Sucursal>> obtenerSucursales();
  Future<List<Piso>> getPisos(String sucursalId);
  Future<List<Mesa>> getMesas(String sucursalId, String pisoId);
  Future<Sucursal> buscarSucursalPorId(String id);
  Future<void> crear(Sucursal sucursal);
  Future<void> actualizar(Sucursal sucursal);
  Future<void> cambiarEstado(Sucursal sucursal);
  Future<void> eliminar(Sucursal sucursal);
}
