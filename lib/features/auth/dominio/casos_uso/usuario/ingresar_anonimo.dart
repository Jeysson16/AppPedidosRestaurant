import 'package:restaurant_app/features/auth/dominio/entidades/usuario.dart';
import 'package:restaurant_app/features/auth/dominio/repositorios/auth_repositorio.dart';

class IngresarAnonimo {
  final AuthRepository repository;

  IngresarAnonimo(this.repository);

  Future<Usuario?> call() async {
    return await repository.ingresarComoInvitado();
  }
}