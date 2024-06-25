import 'package:restaurant_app/features/mesa/dominio/entidades/piso.dart';

abstract class PisoRepository {
  Future<Piso> buscarPisoPorId(String id);
  Stream<List<Piso>> obtenerTodosLosPisos();
  Future<void> crearPisoConMesas(Piso piso);
  Future<void> actualizarPiso(Piso piso);
  Future<void> eliminarPiso(String id);
}