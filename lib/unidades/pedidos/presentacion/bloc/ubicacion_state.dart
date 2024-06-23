import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';


abstract class UbicacionState extends Equatable {
  const UbicacionState();

  @override
  List<Object> get props => [];
}

class UbicacionInitial extends UbicacionState {}

class UbicacionLoading extends UbicacionState {}

class UbicacionSucursalesLoaded extends UbicacionState {
  final List<Position> ubicaciones;

  const UbicacionSucursalesLoaded(this.ubicaciones);

  @override
  List<Object> get props => [ubicaciones];
}

class UbicacionTiempoRealLoaded extends UbicacionState {
  final Position ubicacion;

  const UbicacionTiempoRealLoaded(this.ubicacion);

  @override
  List<Object> get props => [ubicacion];
}

class UbicacionManualLoaded extends UbicacionState {
  final Position ubicacion;

  const UbicacionManualLoaded(this.ubicacion);

  @override
  List<Object> get props => [ubicacion];

}

class SugerenciasLoaded extends UbicacionState {
  final List<String> sugerencias;

  const SugerenciasLoaded(this.sugerencias);
}

class UbicacionGuardada extends UbicacionState {}

class DistanciaCalculada extends UbicacionState {
  final double distancia;
  final double costoDelivery;

  const DistanciaCalculada(this.distancia, this.costoDelivery);

  @override
  List<Object> get props => [distancia, costoDelivery];
}

class TiempoCaminandoCalculado extends UbicacionState {
  final double tiempo;

  const TiempoCaminandoCalculado(this.tiempo);

  @override
  List<Object> get props => [tiempo];
}

class TiempoMotoCalculado extends UbicacionState {
  final double tiempo;

  const TiempoMotoCalculado(this.tiempo);

  @override
  List<Object> get props => [tiempo];
}

class CobroCalculado extends UbicacionState {
  final double cobro;

  const CobroCalculado(this.cobro);

  @override
  List<Object> get props => [cobro];
}

class UbicacionError extends UbicacionState {
  final String mensaje;

  const UbicacionError(this.mensaje);

  @override
  List<Object> get props => [mensaje];
}

class GeocodificacionCompleta extends UbicacionState {
  final Position posicion;

  const GeocodificacionCompleta(this.posicion);

  @override
  List<Object> get props => [posicion];
}

class SucursalesLoaded extends UbicacionState {
  final List<Sucursal> sucursales;

  const SucursalesLoaded(this.sucursales);

  @override
  List<Object> get props => [sucursales];
}

class ModoTemaObtenido extends UbicacionState {
  final String modoTema;

  const ModoTemaObtenido(this.modoTema);

  @override
  List<Object> get props => [modoTema];
}

class UbicacionBuscada extends UbicacionState {
  final Position posicion;

  const UbicacionBuscada(this.posicion);
}

class ModoTemaEstablecido extends UbicacionState {
  final String modoTema;

  const ModoTemaEstablecido(this.modoTema);

  @override
  List<Object> get props => [modoTema];
}

class UrlTemplateObtenido extends UbicacionState {
  final String urlTemplate;

  const UrlTemplateObtenido(this.urlTemplate);

  @override
  List<Object> get props => [urlTemplate];
}

class UbicacionCambiada extends UbicacionState {
  final LatLng nuevaUbicacion;

  const UbicacionCambiada(this.nuevaUbicacion);

  @override
  List<Object> get props => [nuevaUbicacion];
}
