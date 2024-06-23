import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:typed_data';

class ProductoService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadImageBytes(Uint8List imageBytes, String sucursalId,
      String productId, String fileName) async {
    try {
      final ref = _storage
          .ref()
          .child('sucursal/$sucursalId/productos/$productId/$fileName');
      UploadTask uploadTask = ref.putData(imageBytes);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  Future<String> uploadImageFile(File imageFile, String sucursalId,
      String productId, String fileName) async {
    try {
      final ref = _storage
          .ref()
          .child('sucursal/$sucursalId/productos/$productId/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error al subir imagen: $e');
    }
  }

  Future<void> addProducto({
    required String sucursalId,
    required String categoriaId,
    required String nombre,
    required String descripcion,
    required double precio,
    required String imagenPrincipal,
    required List<String> galeria,
  }) async {
    try {
      await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('categoria')
          .doc(categoriaId)
          .collection('producto')
          .add({
        'nombre': nombre,
        'descripcion': descripcion,
        'precio': precio,
        'imagenPrincipal': imagenPrincipal,
        'galeria': galeria,
        'categoriaId': categoriaId,
      });
    } catch (e) {
      throw Exception('Error al agregar el producto: $e');
    }
  }

  Future<List<DocumentSnapshot>> getCategorias(String sucursalId) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('categoria')
          .get();
      return querySnapshot.docs;
    } catch (e) {
      throw Exception('Error obteniendo categorías: $e');
    }
  }

  Future<List<DocumentSnapshot>> getProductosPorCategoria(
      String sucursalId, String categoriaId) async {
    try {
      QuerySnapshot productosSnapshot = await _firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('categoria')
          .doc(categoriaId)
          .collection('producto')
          .get();
      return productosSnapshot.docs;
    } catch (e) {
      print('Error al cargar productos por categoría: $e');
      rethrow;
    }
  }
}
