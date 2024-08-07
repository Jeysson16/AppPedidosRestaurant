import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/mesa_repositorio.dart';

class FirebaseMesaRepository implements MesaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Mesa> buscarMesaPorId(String id) async {
    DocumentSnapshot doc = await _firestore.collection('mesa').doc(id).get();
    return Mesa.fromJson(doc.data() as Map<String, dynamic>);
  }

  @override
  Future<void> crearMesa(Mesa mesa) async {
    await _firestore.collection('mesa').add(mesa.toJson());
  }

  @override
  Future<void> actualizarMesa(Mesa mesa) async {
    await _firestore.collection('mesa').doc(mesa.id).update(mesa.toJson());
  }

  @override
  Future<void> eliminarMesa(String id) async {
    await _firestore.collection('mesa').doc(id).delete();
  }

  @override
  Stream<List<Mesa>> obtenerTodasLasMesas(String pisoId) {
    return _firestore
        .collection('piso')
        .doc(pisoId)
        .collection('mesa')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Mesa.fromJson(doc.data())).toList());
  }

  @override
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
      print('Error al actualizar estado de la mesa: $e');
      throw ("Error al actualizar estado de la mesa. Detalles: $e");
    }
  }
}
