import 'package:restaurant_app/domain/entidades/mesa.dart';

abstract class MesaRepository {
  Future<Mesa> buscarMesaPorId(String id);
  Stream<List<Mesa>> obtenerTodasLasMesas(String pisoId);
  Future<void> crearMesa(Mesa mesa);
  Future<void> actualizarMesa(Mesa mesa);
  Future<void> eliminarMesa(String id);
}