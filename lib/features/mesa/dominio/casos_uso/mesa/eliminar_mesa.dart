import 'package:restaurant_app/features/mesa/dominio/repositorios/mesa_repositorio.dart';

class EliminarMesaCasodeUso {
  final MesaRepository repository;

  EliminarMesaCasodeUso(this.repository);

  Future<void> execute(String id) {
    return repository.eliminarMesa(id);
  }
}