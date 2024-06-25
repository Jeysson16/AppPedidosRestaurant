import 'package:restaurant_app/features/autenticacion/dominio/entidades/cargo.dart';
import 'package:restaurant_app/features/autenticacion/dominio/repositorios/cargo_repositorio.dart';

class ActualizarCargoUseCase {
  final CargoRepository repository;

  ActualizarCargoUseCase(this.repository);

  Future<void> execute(Cargo cargo) {
    return repository.actualizarCargo(cargo);
  }
}
