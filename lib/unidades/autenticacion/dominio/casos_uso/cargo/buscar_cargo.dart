
import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/cargo.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/repositorios/cargo_repositorio.dart';

class BuscarCargoPorIdCasoDeUso {
  final CargoRepository repository;

  BuscarCargoPorIdCasoDeUso(this.repository);

  Future<Cargo> execute(String id) {
    return repository.buscarCargoPorId(id);
  }
}
