import 'package:restaurant_app/features/auth/dominio/entidades/cargo.dart';
import 'package:restaurant_app/features/auth/dominio/repositorios/cargo_repositorio.dart';

class BuscarTodosLosCargosUseCase {
  final CargoRepository repository;

  BuscarTodosLosCargosUseCase(this.repository);

  Future<List<Cargo>> execute(String sucursalId) {
    return repository.buscarTodosLosCargos(sucursalId);
  }
}
