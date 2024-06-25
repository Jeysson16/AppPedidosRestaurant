import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

abstract class UbicacionEvent extends Equatable {
  const UbicacionEvent();

  @override
  List<Object> get props => [];
}

class ObtenerUbicacionSucursalesEvent extends UbicacionEvent {}

class ObtenerUbicacionTiempoRealEvent extends UbicacionEvent {}

class GuardarUbicacionEvent extends UbicacionEvent {
  final Position ubicacion;

  const GuardarUbicacionEvent(this.ubicacion);

  @override
  List<Object> get props => [ubicacion];
}

class BuscarUbicacionManualEvent extends UbicacionEvent {
  final String direccion;

  const BuscarUbicacionManualEvent(this.direccion);

  @override
  List<Object> get props => [direccion];
}

class CalcularDistanciaEvent extends UbicacionEvent {
  final Position origen;
  final Position destino;

  const CalcularDistanciaEvent(this.origen, this.destino);

  @override
  List<Object> get props => [origen, destino];
}

class CalcularTiempoCaminandoEvent extends UbicacionEvent {
  final double distancia;

  const CalcularTiempoCaminandoEvent(this.distancia);

  @override
  List<Object> get props => [distancia];
}

class CalcularTiempoMotoEvent extends UbicacionEvent {
  final double distancia;

  const CalcularTiempoMotoEvent(this.distancia);

  @override
  List<Object> get props => [distancia];
}

class CalcularCobroEvent extends UbicacionEvent {
  final double tiempoMoto;

  const CalcularCobroEvent(this.tiempoMoto);

  @override
  List<Object> get props => [tiempoMoto];
}

class GeocodificarDireccionEvent extends UbicacionEvent {
  final String direccion;

  const GeocodificarDireccionEvent(this.direccion);

  @override
  List<Object> get props => [direccion];
}

class GeocodificarCoordenadasEvent extends UbicacionEvent {
  final double latitude;
  final double longitude;

  const GeocodificarCoordenadasEvent(this.latitude, this.longitude);

  @override
  List<Object> get props => [latitude, longitude];
}

class ObtenerSucursalesEvent extends UbicacionEvent {}

class ObtenerUrlTemplateEvent extends UbicacionEvent {
  final String modoTema;

  const ObtenerUrlTemplateEvent(this.modoTema);
}

class EstablecerModoTemaEvent extends UbicacionEvent {
  final String modoTema; // "claro" o "oscuro"

  const EstablecerModoTemaEvent(this.modoTema);

  @override
  List<Object> get props => [modoTema];
}

class ObtenerModoTemaEvent extends UbicacionEvent {}

class CambiarUbicacionEvent extends UbicacionEvent {
  final LatLng nuevaUbicacion;

  const CambiarUbicacionEvent(this.nuevaUbicacion);

  @override
  List<Object> get props => [nuevaUbicacion];
}

class ObtenerSugerenciasEvent extends UbicacionEvent {
  final String query;

  const ObtenerSugerenciasEvent(this.query);
}
