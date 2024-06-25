
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/banner.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/banner_repositorio.dart';

class BannerRepositorioImpl implements BannerRepository {
  final FirebaseFirestore firestore;

  BannerRepositorioImpl({required this.firestore});
  
  //Sucursal de prueba usada, cambiar la cadena del doc por el valor de la variable sucursalId
  @override
  Future<List<BannerOfertas>> obtenerBanners(String sucursalId) async {
    List<BannerOfertas> banners = [];
    final bannersSnapshot = await firestore
        .collection('sucursal')
        .doc(sucursalId)
        .collection('banner')
        .get();
    for (var bannerDoc in bannersSnapshot.docs) {
      banners.add(BannerOfertas.fromJson(bannerDoc.data()));
    }
    return banners;
  }
}