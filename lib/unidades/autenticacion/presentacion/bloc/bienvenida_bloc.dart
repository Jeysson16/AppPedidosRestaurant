import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/casos_uso/empleado/obtener_empleado.dart';
import 'package:restaurant_app/unidades/autenticacion/presentacion/bloc/bienvenida_event.dart';
import 'package:restaurant_app/unidades/autenticacion/presentacion/bloc/bienvenida_state.dart';

class BienvenidaBloc extends Bloc<BienvenidaEvent, BienvenidaState> {
  final ObtenerEmpleadoCasodeUso obtenerEmpleadoCasoDeUso;

  BienvenidaBloc({required this.obtenerEmpleadoCasoDeUso}) : super(BienvenidaInitial()) {
    on<CheckAuthEvent>(_onCheckAuthEvent);
  }

  Future<void> _onCheckAuthEvent(
      CheckAuthEvent event, Emitter<BienvenidaState> emit) async {
    emit(BienvenidaLoading());
    try {
      final empleado = await obtenerEmpleadoCasoDeUso.execute();
      emit(BienvenidaAuthenticated(empleado));
    } catch (e) {
      emit(BienvenidaUnauthenticated());
    }
  }
}
