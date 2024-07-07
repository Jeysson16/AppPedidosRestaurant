import 'dart:typed_data';
import '../entidades/producto.dart';

abstract class ProductoRepository {
  Future<void> addProducto(Producto producto);
  Future<Producto> buscarProducto(
      String sucursalId, String categoriaId, String productoId);
  Future<List<Producto>> getProductosPorCategoria(
      String sucursalId, String categoriaId);
  Future<void> updateProducto(Producto producto);
  Future<void> deleteProducto(String productoId);
  Future<String> uploadImage(Uint8List imageBytes, String sucursalId,
      String productId, String fileName);
  Future<List<String>> uploadGalleryImages(
      List<Uint8List> imagesBytes, String sucursalId, String productId);
}
