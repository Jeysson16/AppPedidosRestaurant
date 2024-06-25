import 'package:restaurant_app/features/autenticacion/dominio/entidades/cargo.dart';

abstract class CargoRepository {
  Future<Cargo> buscarCargoPorId(String id);
  Future<List<Cargo>> buscarTodosLosCargos(String sucursalId);
  Future<void> crearCargo(Cargo cargo);
  Future<void> actualizarCargo(Cargo cargo);
  Future<void> eliminarCargo(String id);
}