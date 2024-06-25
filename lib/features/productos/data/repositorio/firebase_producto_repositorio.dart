// data/repositories/firebase_producto_repository.dart
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/agregado.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/tamano.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/variante.dart';
import '../../dominio/entidades/producto.dart';
import '../../dominio/repositorio/producto_repositorio.dart';

class FirebaseProductoRepository implements ProductoRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<void> addProducto(Producto producto) async {
    await _firestore.collection('producto').add({
      'nombre': producto.nombre,
      'precio': producto.precio,
      'promocion': producto.promocion,
      'imagenPrincipal': producto.imagenPrincipal,
      'descripcion': producto.descripcion,
      'galeria': producto.galeria,
      'tamano': producto.tamanos?.map((e) => e.toJson()).toList(),
      'variante': producto.variantes?.map((e) => e.toJson()).toList(),
      'agregado': producto.agregados?.map((e) => e.toJson()).toList(),
    });
  }

  //Sucursal de La esperanza en este caso:
  @override
  Future<List<Producto>> getProductosPorCategoria(String sucursalId, String categoriaId) async {
    QuerySnapshot query = await _firestore
        .collection('sucursal')
        //cambiar a sucursalId, la variable que se recibe por parametro
        .doc(sucursalId)
        .collection('categoria')
        .doc(categoriaId)
        .collection('producto')
        .get();
    return query.docs
        .map((doc) => Producto(
              id: doc['id'],
              nombre: doc['nombre'],
              descripcion: doc['descripcion'],
              precio: doc['precio'],
              promocion: doc['promocion'],
              imagenPrincipal: doc['imagenPrincipal'],
              galeria: List<String>.from(doc['galeria']),
              tamanos: List<Tamano>.from(doc['tamano']),
              variantes: List<Variante>.from(doc['variante']),
              agregados: List<Agregado>.from(doc['agregado']),
            ))
        .toList();
  }

  @override
  Future<void> updateProducto(Producto producto) async {
    await _firestore.collection('producto').doc(producto.id).update({
      'nombre': producto.nombre,
      'precio': producto.precio,
      'promocion': producto.promocion,
      'descripcion': producto.descripcion,
      'imagenPrincipal': producto.imagenPrincipal,
      'galeria': producto.galeria,
      'tamano': producto.tamanos?.map((e) => e.toJson()).toList(),
      'variante': producto.variantes?.map((e) => e.toJson()).toList(),
      'agregado': producto.agregados?.map((e) => e.toJson()).toList(),
    });
  }

  @override
  Future<void> deleteProducto(String productoId) async {
    await _firestore.collection('productos').doc(productoId).delete();
  }

  @override
  Future<String> uploadImage(Uint8List imageBytes, String sucursalId, String productId, String fileName) async {
    try {
      final ref = _storage.ref().child('sucursal/$sucursalId/producto/$productId/$fileName');
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
        final ref = _storage.ref().child('sucursal/$sucursalId/producto/$productId/$fileName');
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
