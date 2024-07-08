import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/pedido.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/pedido_repositorio.dart';

class FirebasePedidoRepository implements PedidoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'pedidos';
  @override
  Future<Pedido> buscarPedidoPorId(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection(_collectionPath).doc(id).get();
      if (doc.exists) {
        return Pedido.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception(
            'Pedido no encontrado'); // Lanzar una excepción si no se encuentra el pedido
      }
    } catch (e) {
      throw ("Error al buscar pedido por ID: $e"); // Re-lanzar el error para que sea manejado por quien llama a este método
    }
  }

  @override
  Future<List<Pedido>> obtenerTodosLosPedidos(String sucursalId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collectionPath)
          .where('sucursalId', isEqualTo: sucursalId)
          .get();
      List<Pedido> pedidos = query.docs
          .map((doc) => Pedido.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return pedidos;
    } catch (e) {
      throw ("Error al obtener todos los pedidos: $e");
    }
  }

  @override
  Future<void> crearPedido(Pedido pedido) async {
    try {
      // Guardar el pedido en la colección principal 'pedidos'
      DocumentReference pedidoRef =
          await _firestore.collection(_collectionPath).add(pedido.toJson());

      // Guardar los detalles del pedido en una subcolección 'detallesPedido'
      await _guardarDetallesPedido(pedidoRef.id, pedido.detalles ?? []);
    } catch (e) {
      throw ("Error al crear pedido. Detalles: $e");
    }
  }

  Future<void> _guardarDetallesPedido(
      String pedidoId, List<DetallePedido> detalles) async {
    try {
      // Referencia a la subcolección 'detallesPedido' dentro del documento de pedido
      CollectionReference detallesRef = _firestore
          .collection(_collectionPath)
          .doc(pedidoId)
          .collection('detallesPedido');

      // Crear documentos individuales para cada detalle del pedido
      for (var detalle in detalles) {
        // Asignar el pedidoId al detalle del pedido
        var detalleData = detalle.toJson();
        detalleData['pedidoId'] = pedidoId; // Añadir el pedidoId al detalle

        await detallesRef.doc().set(detalle.toJson());
      }
    } catch (e) {
      throw ("Error al guardar detalles del pedido. Detalles: $e");
    }
  }

  Future<void> actualizarEstado(
      String estado, String sucursalId, String mesaId, String pisoId) async {
    try {
      // Obtener la referencia de la mesa específica dentro de la estructura anidada
      DocumentReference mesaRef = _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('piso')
          .doc(pisoId)
          .collection('mesa')
          .doc(mesaId);

      // Actualizar el estado de la mesa
      await mesaRef.update({'estado': estado});
    } catch (e) {
      throw ("Error al actualizar estado de la mesa. Detalles: $e");
    }
  }

  @override
  Future<void> actualizarPedido(Pedido pedido) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(pedido.id)
          .update(pedido.toJson());
    } catch (e) {
      throw ("Error al actualizar pedido: $e");
    }
  }

  @override
  Future<void> eliminarPedido(String id) async {
    try {
      await _firestore.collection(_collectionPath).doc(id).delete();
    } catch (e) {
      throw ("Error al eliminar pedido: $e");
    }
  }

  @override
  Stream<List<Pedido>> obtenerPedidosEnTiempoReal(String sucursalId) {
    try {
      return _firestore
          .collection(_collectionPath)
          .where('sucursalId', isEqualTo: sucursalId)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs
              .map((doc) => Pedido.fromJson(doc.data() as Map<String, dynamic>))
              .toList());
    } catch (e) {
      return Stream.value([]);
    }
  }

  @override
  Future<List<Pedido>> obtenerPedidosPorEstado(
      String mesaId, String estado) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collectionPath)
          .where('mesaId', isEqualTo: mesaId)
          .where('estado', isEqualTo: estado)
          .get();
      List<Pedido> pedidos = query.docs
          .map((doc) => Pedido.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return pedidos;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> actualizarEstadoPedido(String pedidoId, String estado) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(pedidoId)
          .update({'estado': estado});
    } catch (e) {
      throw ("Error al actualizar estado del pedido: $e");
    }
  }

  @override
  Future<List<Pedido>> obtenerPedidosPorRangoDeFecha(
      String mesaId, DateTime fechaInicio, DateTime fechaFin) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collectionPath)
          .where('mesaId', isEqualTo: mesaId)
          .where('fecha', isGreaterThanOrEqualTo: fechaInicio)
          .where('fecha', isLessThanOrEqualTo: fechaFin)
          .get();
      List<Pedido> pedidos = query.docs
          .map((doc) => Pedido.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      return pedidos;
    } catch (e) {
      return [];
    }
  }

  @override
  Future<int> contarPedidosPorEstado(String mesaId, String estado) async {
    try {
      QuerySnapshot query = await _firestore
          .collection(_collectionPath)
          .where('mesaId', isEqualTo: mesaId)
          .where('estado', isEqualTo: estado)
          .get();
      return query.size;
    } catch (e) {
      return 0;
    }
  }
}
