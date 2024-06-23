import 'package:restaurant_app/domain/entidades/mesa.dart';
import 'package:restaurant_app/domain/repositorios/mesa_repositorio.dart';

class BuscarMesaPorIdCasodeUso {
  final MesaRepository repository;

  BuscarMesaPorIdCasodeUso(this.repository);

  Future<Mesa> execute(String id) {
    return repository.buscarMesaPorId(id);
  }
}