import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/cargo.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/cargo_repositorio.dart';

class FirebaseCargoRepository implements CargoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Cargo> buscarCargoPorId(String id) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('cargos').doc(id).get();
      if (doc.exists) {
        return Cargo.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('Cargo no encontrado');
      }
    } catch (e) {
      throw Exception('Error buscando cargo por ID: $e');
    }
  }

  @override
  Future<List<Cargo>> buscarTodosLosCargos(String sucursalId) async {
    try {
      QuerySnapshot query = await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('cargo')
          .get();
      return query.docs
          .map((doc) => Cargo.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Error buscando todos los cargos: $e');
    }
  }

  @override
  Future<void> crearCargo(Cargo cargo) async {
    try {
      await _firestore.collection('cargos').add(cargo.toJson());
    } catch (e) {
      throw Exception('Error creando cargo: $e');
    }
  }

  @override
  Future<void> actualizarCargo(Cargo cargo) async {
    try {
      await _firestore.collection('cargos').doc(cargo.id).update(cargo.toJson());
    } catch (e) {
      throw Exception('Error actualizando cargo: $e');
    }
  }

  @override
  Future<void> eliminarCargo(String id) async {
    try {
      await _firestore.collection('cargos').doc(id).delete();
    } catch (e) {
      throw Exception('Error eliminando cargo: $e');
    }
  }
}
