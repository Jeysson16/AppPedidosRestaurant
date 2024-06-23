import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/auth_repositorio.dart';

class IniciarSesionCasodeUso {
  final AuthRepository repository;

  IniciarSesionCasodeUso(this.repository);

  Future<void> execute(String email, String password) {
    return repository.iniciarSesion(email, password);
  }
}
