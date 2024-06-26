import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';

class EstablecerModoTema {
  final UbicacionRepositorio repository;

  EstablecerModoTema(this.repository);

  Future<void> call(String modoTema) async {
    return await repository.establecerModoTema(modoTema);
  }
}
