import 'package:restaurant_app/features/autenticacion/dominio/entidades/empleado.dart';
import 'package:restaurant_app/features/autenticacion/dominio/repositorios/auth_repositorio.dart';

class ObtenerEmpleadoCasodeUso {
  final AuthRepository repository;

  ObtenerEmpleadoCasodeUso(this.repository);

  Future<Empleado> execute() {
    return repository.obtenerEmpleado();
  }
}