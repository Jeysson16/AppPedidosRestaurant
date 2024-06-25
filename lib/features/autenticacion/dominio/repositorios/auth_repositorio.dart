import 'package:restaurant_app/features/autenticacion/dominio/entidades/empleado.dart';
import 'package:restaurant_app/features/autenticacion/dominio/entidades/usuario.dart';

abstract class AuthRepository {
  Future<void> registrarEmpleado(String email, String password, Map<String, dynamic> employeeData);
  Future<void> iniciarSesion(String email, String password);
  Future<void> cerrarSesion();
  Future<Empleado> obtenerEmpleado();
  Future<Usuario?> ingresarComoInvitado();
}