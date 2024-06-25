import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/mesa_repositorio.dart';

class BuscarMesaPorIdCasodeUso {
  final MesaRepository repository;

  BuscarMesaPorIdCasodeUso(this.repository);

  Future<Mesa> execute(String id) {
    return repository.buscarMesaPorId(id);
  }
}