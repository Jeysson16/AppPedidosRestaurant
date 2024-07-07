import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/productos/data/repositorio/firebase_categoria_repositorio.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_event.dart';
import 'package:restaurant_app/features/productos/presentacion/bloc/categoria/categoria_producto_state.dart';

class ProductosBloc extends Bloc<ProductosEvent, ProductosState> {
  final CategoriaProductosRepositoryImpl categoriaProductosRepository;
  ProductosBloc(this.categoriaProductosRepository) : super(ProductosInitial()) {
    on<LoadProductos>(_onLoadProductos);
  }

  void _onLoadProductos(
      LoadProductos event, Emitter<ProductosState> emit) async {
    emit(ProductosLoading());
    try {
      final categoriasConProductos = await categoriaProductosRepository
          .obtenerCategoriasConProductos(event.sucursalId);
      emit(ProductosLoaded(categoriasConProductos));
    } catch (e) {
      emit(ProductosError(e.toString()));
    }
  }
}
