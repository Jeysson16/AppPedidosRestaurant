import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/cargo.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/cargo_repositorio.dart';

class CrearCargoUseCase {
  final CargoRepository repository;

  CrearCargoUseCase(this.repository);

  Future<void> execute(Cargo cargo) {
    return repository.crearCargo(cargo);
  }
}
