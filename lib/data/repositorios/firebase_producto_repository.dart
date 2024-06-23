// data/repositories/firebase_producto_repository.dart
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_app/domain/entidades/agregado.dart';
import 'package:restaurant_app/domain/entidades/tamano.dart';
import 'package:restaurant_app/domain/entidades/variante.dart';
import '../../domain/entidades/producto.dart';
import '../../domain/repositorios/producto_repositorio.dart';

class FirebaseProductoRepository implements ProductoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> addProducto(Producto producto) async {
    await _firestore.collection('productos').add({
      'nombre': producto.nombre,
      'precio': producto.precio,
      'promocion': producto.promocion,
      'imagenPrincipal': producto.imagenPrincipal,
      'galeria': producto.galeria,
      'tamanos': producto.tamanos?.map((e) => e.toJson()).toList(),
      'variantes': producto.variantes?.map((e) => e.toJson()).toList(),
      'agregados': producto.agregados?.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<List<Producto>> getProductosPorCategoria(String sucursalId, String categoriaId) async {
    QuerySnapshot query = await _firestore
        .collection('sucursal')
        .doc(sucursalId)
        .collection('categoria')
        .doc(categoriaId)
        .collection('producto')
        .get();
    return query.docs
        .map((doc) => Producto(
              id: doc.id,
              nombre: doc['nombre'],
              precio: doc['precio'],
              promocion: doc['promocion'],
              imagenPrincipal: doc['imagenPrincipal'],
              galeria: List<String>.from(doc['galeria']),
              tamanos: List<Tamano>.from(doc['tamanos']),
              variantes: List<Variante>.from(doc['variantes']),
              agregados: List<Agregado>.from(doc['agregados']),
            ))
        .toList();
  }

  @override
  Future<void> updateProducto(Producto producto) async {
    await _firestore.collection('productos').doc(producto.id).update({
      'nombre': producto.nombre,
      'precio': producto.precio,
      'promocion': producto.promocion,
      'imagenPrincipal': producto.imagenPrincipal,
      'galeria': producto.galeria,
      'tamanos': producto.tamanos?.map((e) => e.toJson()).toList(),
      'variantes': producto.variantes?.map((e) => e.toJson()).toList(),
      'agregados': producto.agregados?.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<void> deleteProducto(String productoId) async {
    await _firestore.collection('productos').doc(productoId).delete();
  }

  @override
  Future<String> uploadImage(Uint8List imageBytes, String sucursalId, String productId, String fileName) async {
    try {
      final ref = _storage.ref().child('sucursal/$sucursalId/productos/$productId/$fileName');
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  @override
  Future<List<String>> uploadGalleryImages(List<Uint8List> imagesBytes, String sucursalId, String productId) async {
    try {
      List<String> downloadUrls = [];
      for (int i = 0; i < imagesBytes.length; i++) {
        String fileName = 'gallery_image_$i.jpg';
        final ref = _storage.ref().child('sucursal/$sucursalId/productos/$productId/$fileName');
        UploadTask uploadTask = ref.putData(imagesBytes[i]);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }
      return downloadUrls;
    } catch (e) {
      throw Exception('Error uploading gallery images: $e');
    }
  }
}
