import 'package:restaurant_app/features/productos/dominio/entidades/categoria.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/categoria_productos.dart';

abstract class CategoriaRepository {
  Future<Categoria> buscarCategoriaPorId(String id);
  Future<List<Categoria>> obtenerTodasLasCategorias(String sucursalId);
  Future<void> crearCategoria(Categoria categoria);
  Future<void> actualizarCategoria(Categoria categoria);
  Future<void> eliminarCategoria(String id);
  Future<List<CategoriaConProductos>> buscarCategoriasPorNombre(String nombre, String sucursalId);
  Future<List<CategoriaConProductos>> obtenerCategoriasConProductos(String sucursalId);
}