import 'package:restaurant_app/domain/entidades/mesa.dart';
import 'package:restaurant_app/domain/repositorios/mesa_repositorio.dart';

class ObtenerTodasLasMesasCasodeUso {
  final MesaRepository repository;

  ObtenerTodasLasMesasCasodeUso(this.repository);

  Stream<List<Mesa>> execute(String pisoId) {
    return repository.obtenerTodasLasMesas(pisoId);
  }
}