// features/productos/dominio/uso_cases/obtener_banners.dart
import 'package:restaurant_app/features/productos/dominio/entidades/banner.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/banner_repositorio.dart';

class ObtenerBanners {
  final BannerRepository repository;

  ObtenerBanners(this.repository);

  Future<List<BannerOfertas>> call(String sucursalId) async {
    return await repository.obtenerBanners(sucursalId);
  }
}