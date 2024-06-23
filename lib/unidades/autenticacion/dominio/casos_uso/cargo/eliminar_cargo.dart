import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/cargo_repositorio.dart';

class EliminarCargoUseCase {
  final CargoRepository repository;

  EliminarCargoUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.eliminarCargo(id);
  }
}
