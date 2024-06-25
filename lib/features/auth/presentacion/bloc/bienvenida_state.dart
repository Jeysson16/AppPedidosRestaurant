import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/auth/dominio/entidades/empleado.dart';

abstract class BienvenidaState extends Equatable {
  const BienvenidaState();

  @override
  List<Object> get props => [];
}

class BienvenidaInitial extends BienvenidaState {}

class BienvenidaLoading extends BienvenidaState {}

class BienvenidaAuthenticated extends BienvenidaState {
  final Empleado empleado;

  const BienvenidaAuthenticated(this.empleado);

  @override
  List<Object> get props => [empleado];
}

class BienvenidaUnauthenticated extends BienvenidaState {}
