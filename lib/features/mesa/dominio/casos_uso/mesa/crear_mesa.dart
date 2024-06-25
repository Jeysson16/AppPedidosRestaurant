import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/mesa_repositorio.dart';

class CrearMesaCasodeUso {
  final MesaRepository repository;

  CrearMesaCasodeUso(this.repository);

  Future<void> execute(Mesa mesa) {
    return repository.crearMesa(mesa);
  }
}