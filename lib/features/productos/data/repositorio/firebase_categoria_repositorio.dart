import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/agregado.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/categoria.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/tamano.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/variante.dart';
import 'package:restaurant_app/features/productos/dominio/repositorio/categoria_repositorio.dart';

class CategoriaProductosRepositoryImpl implements CategoriaRepository {
  final FirebaseFirestore firestore;

  CategoriaProductosRepositoryImpl({required this.firestore});

  @override
  Future<List<CategoriaProductos>> obtenerCategoriasConProductos(String sucursalId) async {
    final categoriasSnapshot = await firestore
        .collection('sucursal')
        .doc(sucursalId)
        .collection('categoria')
        .get();

    List<CategoriaProductos> categoriasConProductos = [];

    for (var categoriaDoc in categoriasSnapshot.docs) {
      final categoriaData = categoriaDoc.data();
      final productosSnapshot = await firestore
          .collection('sucursal')
          .doc(sucursalId)
          .collection('categoria')
          .doc(categoriaDoc.id)
          .collection('producto')
          .get();

      List<Producto> productos = productosSnapshot.docs.map((productoDoc) {
        final productoData = productoDoc.data();
        return Producto(
          id: productoDoc.id,
          nombre: productoData['nombre'],
          descripcion: productoData['descripcion'],
          precio: productoData['precio'] is int ? (productoData['precio'] as int).toDouble() : productoData['precio'] as double,
          promocion: productoData['promocion'] != null
              ? productoData['promocion'] is int
                  ? (productoData['promocion'] as int).toDouble()
                  : productoData['promocion'] as double
              : null,
          imagenPrincipal: productoData['imagenPrincipal'],
          galeria: productoData['galeria'] != null ? List<String>.from(productoData['galeria']) : [],
          tamanos: productoData['tamanos'] != null
              ? List<Tamano>.from(productoData['tamanos'].map((t) => Tamano.fromJson(t)))
              : [],
          variantes: productoData['variantes'] != null
              ? List<Variante>.from(productoData['variantes'].map((v) => Variante.fromJson(v)))
              : [],
          agregados: productoData['agregados'] != null
              ? List<Agregado>.from(productoData['agregados'].map((a) => Agregado.fromJson(a)))
              : [],
        );
      }).toList();

      categoriasConProductos.add(
        CategoriaProductos(
          id: categoriaDoc.id,
          nombre: categoriaData['nombre'],
          productos: productos,
        ),
      );
    }

    return categoriasConProductos;
  }

  @override
  Future<void> actualizarCategoria(Categoria categoria) {
    // TODO: implement actualizarCategoria
    throw UnimplementedError();
  }

  @override
  Future<Categoria> buscarCategoriaPorId(String id) {
    // TODO: implement buscarCategoriaPorId
    throw UnimplementedError();
  }

  @override
  Future<List<CategoriaProductos>> buscarCategoriasPorNombre(String nombre, String sucursalId) {
    // TODO: implement buscarCategoriasPorNombre
    throw UnimplementedError();
  }

  @override
  Future<void> crearCategoria(Categoria categoria) {
    // TODO: implement crearCategoria
    throw UnimplementedError();
  }

  @override
  Future<void> eliminarCategoria(String id) {
    // TODO: implement eliminarCategoria
    throw UnimplementedError();
  }

  @override
  Future<List<Categoria>> obtenerTodasLasCategorias(String sucursalId) {
    // TODO: implement obtenerTodasLasCategorias
    throw UnimplementedError();
  }
}