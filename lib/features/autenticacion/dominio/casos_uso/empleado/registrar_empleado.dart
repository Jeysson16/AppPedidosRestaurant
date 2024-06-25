import 'package:restaurant_app/features/autenticacion/dominio/repositorios/auth_repositorio.dart';

class RegistrarEmpleadoCasodeUso {
  final AuthRepository repository;

  RegistrarEmpleadoCasodeUso(this.repository);

  Future<void> execute(String email, String password, Map<String, dynamic> employeeData) {
    return repository.registrarEmpleado(email, password, employeeData);
  }
}