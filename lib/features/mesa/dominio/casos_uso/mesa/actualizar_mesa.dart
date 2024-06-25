import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/mesa_repositorio.dart';

class ActualizarMesaCasodeUso {
  final MesaRepository repository;

  ActualizarMesaCasodeUso(this.repository);

  Future<void> execute(Mesa mesa) {
    return repository.actualizarMesa(mesa);
  }
}
