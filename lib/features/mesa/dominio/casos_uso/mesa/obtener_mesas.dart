import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';
import 'package:restaurant_app/features/mesa/dominio/repositorios/mesa_repositorio.dart';

class ObtenerTodasLasMesasCasodeUso {
  final MesaRepository repository;

  ObtenerTodasLasMesasCasodeUso(this.repository);

  Stream<List<Mesa>> execute(String pisoId) {
    return repository.obtenerTodasLasMesas(pisoId);
  }
}