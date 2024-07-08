import 'package:cloud_firestore/cloud_firestore.dart';

class MesaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getSucursal(String sucursalId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sucursal')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Error obteniendo pisos: $e');
    }
  }
  Future<List<DocumentSnapshot>> getPisos(String sucursalId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('piso')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Error obteniendo pisos: $e');
    }
  }

  Future<List<DocumentSnapshot>> getMesas(
      String sucursalId, String pisoId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('piso')
          .doc(pisoId)
          .collection('mesa')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Error obteniendo mesas: $e');
    }
  }
}
