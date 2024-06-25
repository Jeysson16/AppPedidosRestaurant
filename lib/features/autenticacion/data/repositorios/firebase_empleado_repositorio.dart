// data/repositories/firebase_auth_repository.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/autenticacion/dominio/entidades/empleado.dart';
import 'package:restaurant_app/features/autenticacion/dominio/entidades/usuario.dart';
import 'package:restaurant_app/features/autenticacion/dominio/repositorios/auth_repositorio.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';

class FirebaseAutenticacionRepositorio implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> registrarEmpleado(String email, String password, Map<String, dynamic> empleadoData) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      String sucursalId = empleadoData['sucursal'];
      String cargoId = empleadoData['cargo'];

      empleadoData['id'] = uid;

      // Guarda la información del empleado en Firestore
      await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('cargo')
          .doc(cargoId)
          .collection('empleado')
          .doc(uid)
          .set(empleadoData);
    } catch (e) {
      throw Exception('Error registrando usuario: $e');
    }
  }

  @override
  Future<void> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;
        QuerySnapshot sucursalSnapshot = await _firestore.collection('sucursal').get();

        Empleado? empleado;
        String? sucursalNombre;
        String? sucursalId;
        Map<String, dynamic>? cargoData;
        String? cargoId;

        for (QueryDocumentSnapshot sucursalNode in sucursalSnapshot.docs) {
          if (empleado != null) break;

          sucursalId = sucursalNode.id;
          sucursalNombre = sucursalNode['nombreSucursal'];

          QuerySnapshot cargoSnapshot = await _firestore
              .collection('sucursal')
              .doc(sucursalId)
              .collection('cargo')
              .get();

          for (QueryDocumentSnapshot cargoNode in cargoSnapshot.docs) {
            if (empleado != null) break;

            cargoId = cargoNode.id;
            cargoData = cargoNode.data() as Map<String, dynamic>?;

            DocumentSnapshot empleadoNode =
                await cargoNode.reference.collection('empleado').doc(uid).get();

            if (empleadoNode.exists) {
              Map<String, dynamic> empleadoData = empleadoNode.data() as Map<String, dynamic>;
              empleado = Empleado(
                id: uid,
                celular: empleadoData['celular'],
                nombres: empleadoData['nombre'],
                apellidos: empleadoData['apellidos'],
                correo: empleadoData['correo'],
                salarioBase: empleadoData['salarioBase'],
                edad: empleadoData['edad'],
                dni: empleadoData['dni'],
              );
              break;
            }
          }
        }

        if (empleado != null && cargoData != null && sucursalNombre != null && sucursalId != null && cargoId != null) {
          PreferenciasUsuario prefs = PreferenciasUsuario();
          prefs.empleado = empleado;
          print('Empleado: ${empleado.toJson()}');
        } else {
          throw Exception('No se encontró información del empleado.');
        }
      } else {
        throw Exception('No se encontró el usuario en la autenticación.');
      }
    } catch (e) {
      throw Exception('Error iniciando sesión: $e');
    }
  }

  @override
  Future<void> cerrarSesion() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception('Error cerrando sesión: $e');
    }
  }

  @override
  Future<Empleado> obtenerEmpleado() async {
    final prefs = PreferenciasUsuario();
    Empleado? empleado = prefs.empleado;
    if (empleado != null) {
      return empleado;
    } else {
      throw Exception('No hay empleado autenticado');
    }
  }

  @override
  Future<Usuario?> ingresarComoInvitado() async {
    try {
      final userCredential = await _firebaseAuth.signInAnonymously();
      return Usuario(
        id: userCredential.user!.uid,
        esInvitado: userCredential.user!.isAnonymous,
      );
    } catch (e) {
      return null;
    }
  }
  
}

