import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/auth/dominio/entidades/empleado.dart';
import 'package:restaurant_app/features/auth/dominio/entidades/usuario.dart';
import 'package:restaurant_app/features/auth/dominio/repositorios/auth_repositorio.dart';
import 'package:restaurant_app/app/global/preferencias/pref_usuarios.dart';

class FirebaseAutenticacionRepositorio implements AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> registrarEmpleado(
      String email, String password, Map<String, dynamic> empleadoData) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
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
  Future<bool> iniciarSesion(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        QuerySnapshot sucursalSnapshot =
            await _firestore.collection('sucursal').get();

        Empleado? empleado;
        String? sucursalNombre;
        String? sucursalId;
        Map<String, dynamic>? cargoData;
        String? cargoId;

        for (QueryDocumentSnapshot sucursalNode in sucursalSnapshot.docs) {
          if (empleado != null) break;

          sucursalId = sucursalNode.id;
          sucursalNombre = sucursalNode.get('nombreSucursal') ?? '';

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
              Map<String, dynamic> empleadoData =
                  empleadoNode.data() as Map<String, dynamic>;
              // Asignar valores por defecto si algún campo es nulo
              empleado = Empleado(
                id: uid,
                celular: empleadoData['celular'] ?? 'N/A',
                nombres: empleadoData['nombre'] ?? 'N/A',
                apellidos: empleadoData['apellidos'] ?? 'N/A',
                correo: empleadoData['correo'] ?? 'N/A',
                salarioBase: empleadoData['salarioBase'] ?? '0.0',
                edad: empleadoData['edad'] ?? '0',
                dni: empleadoData['dni'] ?? 'N/A',
              );
              break;
            }
          }
        }

        if (empleado != null &&
            cargoData != null &&
            sucursalNombre != null &&
            sucursalId != null &&
            cargoId != null) {
          await PreferenciasUsuario
              .init(); // Inicializar preferencias antes de usarlas
          PreferenciasUsuario prefs = PreferenciasUsuario();
          prefs.empleado = empleado;
          prefs.sucursalId = sucursalId; // Guardar el ID de sucursal
          return true; // Usuario es un empleado
        } else {
          await PreferenciasUsuario
              .init(); // Inicializar preferencias antes de usarlas
          PreferenciasUsuario prefs = PreferenciasUsuario();
          prefs.usuarioDni = uid;
          return false; // Usuario es un usuario normal
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
        esInvitado: userCredential.user!.isAnonymous,
        nombres: '',
        apellidos: '',
        correo: '',
        dni: '',
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> registerWithEmailAndPassword(String email, String password,
      String nombres, String apellidos, String dni) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String uid = userCredential.user!.uid;

      await PreferenciasUsuario
          .init(); // Inicializar preferencias antes de usarlas
      PreferenciasUsuario prefs = PreferenciasUsuario();
      prefs.usuarioDni = uid;
      Map<String, dynamic> userData;
      // Crear un mapa con los datos del usuario
      if (nombres != null && apellidos != null) {
        userData = {
          'nombres': nombres,
          'apellidos': apellidos,
          'correo': email,
          'dni': dni,
        };
      } else {
        userData = {
          'nombres': ' ',
          'apellidos': ' ',
          'correo': email,
          'dni': dni,
        };
      }
      // Guardar la información del usuario en Firestore
      await _firestore.collection('usuarios').doc(uid).set(userData);
    } catch (e) {
      throw Exception('Error registrando usuario: $e');
    }
  }
}
