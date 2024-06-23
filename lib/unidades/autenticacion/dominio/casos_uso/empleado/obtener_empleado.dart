import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/empleado.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/auth_repositorio.dart';

class ObtenerEmpleadoCasodeUso {
  final AuthRepository repository;

  ObtenerEmpleadoCasodeUso(this.repository);

  Future<Empleado> execute() {
    return repository.obtenerEmpleado();
  }
}