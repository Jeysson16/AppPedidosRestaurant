import 'package:equatable/equatable.dart';
import 'package:restaurant_app/features/autenticacion/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/autenticacion/dominio/entidades/cargo.dart';

abstract class SucursalCargoState extends Equatable {
  const SucursalCargoState();

  @override
  List<Object> get props => [];
}

class SucursalCargoInitial extends SucursalCargoState {}

class SucursalCargoLoading extends SucursalCargoState {}

class SucursalesLoaded extends SucursalCargoState {
  final List<Sucursal> sucursales;

  const SucursalesLoaded(this.sucursales);

  @override
  List<Object> get props => [sucursales];
}

class CargosLoaded extends SucursalCargoState {
  final List<Cargo> cargos;

  const CargosLoaded(this.cargos);

  @override
  List<Object> get props => [cargos];
}

class SucursalCargoFailure extends SucursalCargoState {
  final String error;

  const SucursalCargoFailure(this.error);

  @override
  List<Object> get props => [error];
}
