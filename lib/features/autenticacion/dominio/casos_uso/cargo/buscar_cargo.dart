
import 'package:restaurant_app/features/autenticacion/dominio/entidades/cargo.dart';
import 'package:restaurant_app/features/autenticacion/dominio/repositorios/cargo_repositorio.dart';

class BuscarCargoPorIdCasoDeUso {
  final CargoRepository repository;

  BuscarCargoPorIdCasoDeUso(this.repository);

  Future<Cargo> execute(String id) {
    return repository.buscarCargoPorId(id);
  }
}
