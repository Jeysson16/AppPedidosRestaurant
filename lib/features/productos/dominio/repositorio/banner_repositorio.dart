import 'package:restaurant_app/features/productos/dominio/entidades/banner.dart';

abstract class BannerRepository {
  Future<List<BannerOfertas>> obtenerBanners(String sucursalId);
}