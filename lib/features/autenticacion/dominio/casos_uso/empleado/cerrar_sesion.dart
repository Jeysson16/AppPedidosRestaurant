import 'package:restaurant_app/features/autenticacion/dominio/repositorios/auth_repositorio.dart';

class CerrarSesionCasodeUso {
  final AuthRepository repository;

  CerrarSesionCasodeUso(this.repository);

  Future<void> execute() {
    return repository.cerrarSesion();
  }
}