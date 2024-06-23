import 'package:restaurant_app/domain/entidades/mesa.dart';
import 'package:restaurant_app/domain/repositorios/mesa_repositorio.dart';

class CrearMesaCasodeUso {
  final MesaRepository repository;

  CrearMesaCasodeUso(this.repository);

  Future<void> execute(Mesa mesa) {
    return repository.crearMesa(mesa);
  }
}