import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';

abstract class MesaRepository {
  Future<Mesa> buscarMesaPorId(String id);
  Stream<List<Mesa>> obtenerTodasLasMesas(String pisoId);
  Future<void> crearMesa(Mesa mesa);
  Future<void> actualizarMesa(Mesa mesa);
  Future<void> eliminarMesa(String id);
  Future<void> actualizarEstado(String estado,String sucursalId, String mesaId, String pisoId);
}
