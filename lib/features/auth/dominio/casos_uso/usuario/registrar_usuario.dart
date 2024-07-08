import 'package:restaurant_app/features/auth/data/model/dni_service.dart';
import 'package:restaurant_app/features/auth/data/repositorios/firebase_usuarios_repositorio.dart';

class RegistrarUsuarioCaso {
  final IDniService dniService;
  final FirebaseAutenticacionRepositorio authRepository;

  RegistrarUsuarioCaso({
    required this.dniService,
    required this.authRepository,
  });

  Future<void> ejecutarRegistro(
      String dni, String email, String password) async {
    try {
      // Obtener datos del DNI
      DniData dniData = await dniService.fetchDniData(dni);

      // Extraer nombres y apellidos
      String nombres = dniData.nombres;
      String apellidos =
          '${dniData.apellidoPaterno} ${dniData.apellidoMaterno}';

      // Registrar usuario con Firebase Auth
      await authRepository.registerWithEmailAndPassword(
          email, password, nombres, apellidos, dni);
    } catch (e) {
      throw Exception('Failed to execute user registration: $e');
    }
  }
}
