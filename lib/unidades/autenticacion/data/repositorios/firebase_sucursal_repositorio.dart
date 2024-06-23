import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/sucursal_repositorio.dart';

class FirebaseSucursalRepository implements SucursalRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Sucursal> buscarSucursalPorId(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('sucursales').doc(id).get();
      if (doc.exists) {
        return Sucursal.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Sucursal no encontrada');
      }
    } catch (e) {
      throw Exception('Error buscando sucursal por ID: $e');
    }
  }

  @override
  Future<List<Sucursal>> obtenerSucursales() async {
    try {
      QuerySnapshot query = await _firestore.collection('sucursales').get();
      return query.docs
          .map((doc) => Sucursal.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error obteniendo sucursales: $e');
    }
  }

  @override
  Future<void> crear(Sucursal sucursal) async {
    try {
      await _firestore.collection('sucursales').add(sucursal.toJson());
    } catch (e) {
      throw Exception('Error creando sucursal: $e');
    }
  }

  @override
  Future<void> actualizar(Sucursal sucursal) async {
    try {
      await _firestore.collection('sucursales').doc(sucursal.id).update(sucursal.toJson());
    } catch (e) {
      throw Exception('Error actualizando sucursal: $e');
    }
  }

  @override
  Future<void> cambiarEstado(Sucursal sucursal) async {
    try {
      await _firestore.collection('sucursales').doc(sucursal.id).update({
        'estado': sucursal.estado,
      });
    } catch (e) {
      throw Exception('Error cambiando el estado de la sucursal: $e');
    }
  }

  @override
  Future<void> eliminar(Sucursal sucursal) async {
    try {
      await _firestore.collection('sucursales').doc(sucursal.id).delete();
    } catch (e) {
      throw Exception('Error eliminando sucursal: $e');
    }
  }
}
