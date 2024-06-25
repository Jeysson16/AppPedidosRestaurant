import 'package:equatable/equatable.dart';

abstract class SucursalCargoEvent extends Equatable {
  const SucursalCargoEvent();

  @override
  List<Object> get props => [];
}

class LoadSucursalesEvent extends SucursalCargoEvent {}

class LoadCargosEvent extends SucursalCargoEvent {
  final String sucursalId;

  const LoadCargosEvent(this.sucursalId);

  @override
  List<Object> get props => [sucursalId];
}
