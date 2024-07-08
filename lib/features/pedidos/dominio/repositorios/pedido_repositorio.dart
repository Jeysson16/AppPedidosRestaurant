import 'package:restaurant_app/features/pedidos/dominio/entidades/pedido.dart';

abstract class PedidoRepository {
  
  Future<Pedido> buscarPedidoPorId(String id);
  Future<List<Pedido>> obtenerTodosLosPedidos(String mesaId);
  Future<void> crearPedido(Pedido pedido);
  Future<void> actualizarPedido(Pedido pedido);
  Future<void> eliminarPedido(String id);
  Stream<List<Pedido>> obtenerPedidosEnTiempoReal(String mesaId);
  Future<List<Pedido>> obtenerPedidosPorEstado(String mesaId, String estado);
  Future<void> actualizarEstadoPedido(String pedidoId, String estado);
  Future<List<Pedido>> obtenerPedidosPorRangoDeFecha(String mesaId, DateTime fechaInicio, DateTime fechaFin);
  Future<int> contarPedidosPorEstado(String mesaId, String estado);
}