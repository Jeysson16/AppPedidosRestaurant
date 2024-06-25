
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/piso.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/sucursal_repositorio.dart';

class SucursalRepositoryImpl implements SucursalRepository {
  final FirebaseFirestore firestore;

  SucursalRepositoryImpl(this.firestore);

  @override
  Future<List<Sucursal>> obtenerSucursales() async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('sucursal').get();
      return querySnapshot.docs.map((doc) {
        print(doc.data()); // Imprimir datos del documento para verificar el contenido
        final data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return Sucursal.fromJson(data);
      }).toList();
    } catch (e) {
      throw Exception('Error obteniendo sucursales: $e');
    }
  }

  @override
  Future<List<Piso>> getPisos(String sucursalId) async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('sucursal')
        .doc(sucursalId).collection('piso').get();
      return querySnapshot.docs.map((doc) => Piso.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error obteniendo pisos: $e');
    }
  }

  @override
  Future<List<Mesa>> getMesas(String sucursalId, String pisoId) async {
    try {
      QuerySnapshot querySnapshot = await firestore.collection('sucursal')
        .doc(sucursalId).collection('piso').doc(pisoId).collection('mesa').get();
      return querySnapshot.docs.map((doc) => Mesa.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error obteniendo mesas: $e');
    }
  }

  @override
  Future<void> actualizar(Sucursal sucursal) async {
    try {
      await firestore.collection('sucursal').doc(sucursal.id).update(sucursal.toJson());
    } catch (e) {
      throw Exception('Error actualizando sucursal: $e');
    }
  }

  @override
  Future<Sucursal> buscarSucursalPorId(String id) async {
    try {
      DocumentSnapshot doc = await firestore.collection('sucursal').doc(id).get();
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
  Future<void> cambiarEstado(Sucursal sucursal) async {
    try {
      await firestore.collection('sucursal').doc(sucursal.id).update({
        'estado': sucursal.estado,
      });
    } catch (e) {
      throw Exception('Error cambiando el estado de la sucursal: $e');
    }
  }

  @override
  Future<void> crear(Sucursal sucursal) async {
    try {
      await firestore.collection('sucursal').add(sucursal.toJson());
    } catch (e) {
      throw Exception('Error creando sucursal: $e');
    }
  }

  @override
  Future<void> eliminar(Sucursal sucursal) async {
    try {
      await firestore.collection('sucursal').doc(sucursal.id).delete();
    } catch (e) {
      throw Exception('Error eliminando sucursal: $e');
    }
  }
}