import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/mesa/data/repositorios/firebase_sucursal_repositorio.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
part 'sucursal_event.dart';
part 'sucursal_state.dart';

class SucursalBloc extends Bloc<SucursalEvent, SucursalState> {
  final SucursalRepositoryImpl sucursalRepository;

  SucursalBloc(this.sucursalRepository) : super(SucursalInitial()) {
    on<LoadSucursales>(_onLoadSucursales);
  }

  void _onLoadSucursales(LoadSucursales event, Emitter<SucursalState> emit) async {
    emit(SucursalLoading());
    try {
      final sucursales = await sucursalRepository.obtenerSucursales();
      emit(SucursalLoaded(sucursales));
    } catch (e) {
      emit(SucursalError(e.toString()));
    }
  }
}
