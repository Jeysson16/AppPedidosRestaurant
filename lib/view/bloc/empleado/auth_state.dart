import 'package:equatable/equatable.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/empleado.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final Empleado empleado;

  AuthSuccess(this.empleado);

  @override
  List<Object> get props => [empleado];
}

class AuthFailure extends AuthState {
  final String error;

  AuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
