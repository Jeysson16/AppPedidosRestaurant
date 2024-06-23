import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/casos_uso/empleado/iniciar_sesion.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/casos_uso/empleado/registrar_empleado.dart';
import 'autenticacion_event.dart';
import 'autenticacion_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final RegistrarEmpleadoCasodeUso registrarEmpleadoCasodeUso;

  AuthBloc({required this.registrarEmpleadoCasodeUso, required IniciarSesionCasodeUso iniciarSesionCasodeUso}) : super(AuthInitial()) {
    on<RegistrarEmpleadoEvent>(_onRegistrarEmpleado);
  }

  Future<void> _onRegistrarEmpleado(
      RegistrarEmpleadoEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await registrarEmpleadoCasodeUso.execute(event.email, event.password, event.employeeData);
      emit(AuthSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
