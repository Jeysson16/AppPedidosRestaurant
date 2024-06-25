import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/features/auth/dominio/casos_uso/cargo/buscar_cargo.dart';
import 'package:restaurant_app/features/mesa/dominio/casos_uso/sucursal/obtener_sucursales.dart';
import 'package:restaurant_app/features/auth/dominio/entidades/cargo.dart';
import 'sucursal_cargo_event.dart';
import 'sucursal_cargo_state.dart';

class SucursalCargoBloc extends Bloc<SucursalCargoEvent, SucursalCargoState> {
  final ObtenerSucursalesCasodeUso obtenerSucursalesCasoDeUso;
  final BuscarCargoPorIdCasoDeUso obtenerCargosCasoDeUso;

  SucursalCargoBloc({
    required this.obtenerSucursalesCasoDeUso,
    required this.obtenerCargosCasoDeUso,
  }) : super(SucursalCargoInitial()) {
    on<LoadSucursalesEvent>(_onLoadSucursales);
    on<LoadCargosEvent>(_onLoadCargos);
  }

  Future<void> _onLoadSucursales(
      LoadSucursalesEvent event, Emitter<SucursalCargoState> emit) async {
    emit(SucursalCargoLoading());
    try {
      final sucursales = await obtenerSucursalesCasoDeUso.execute();
      emit(SucursalesLoaded(sucursales));
    } catch (e) {
      emit(SucursalCargoFailure(e.toString()));
    }
  }

  Future<void> _onLoadCargos(
      LoadCargosEvent event, Emitter<SucursalCargoState> emit) async {
    emit(SucursalCargoLoading());
    try {
      final cargos = await obtenerCargosCasoDeUso.execute(event.sucursalId);
      emit(CargosLoaded(cargos as List<Cargo>));
    } catch (e) {
      emit(SucursalCargoFailure(e.toString()));
    }
  }
}
