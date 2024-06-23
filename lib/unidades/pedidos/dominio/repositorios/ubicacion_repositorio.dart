import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/unidades/autenticacion/dominio/entidades/sucursal.dart';

abstract class UbicacionRepositorio {
  Future<List<Sucursal>> obtenerSucursales();
  Future<List<Sucursal>> obtenerUbicacionesSucursales();
  Future<Position> obtenerUbicacionTiempoReal();
  Future<Position> geocodificarDireccion(String direccion);
  Future<Position> geocodificarCoordenadas(double latitude, double longitude);
  double calcularDistancia(Position origen, Position destino);
  double calcularTiempoCaminando(double distancia);
  double calcularTiempoMoto(double distancia);
  double calcularCobro(double tiempoMoto);
  Future<void> establecerModoTema(String modoTema);
  Future<String> obtenerModoTema();
  String obtenerUrlTemplate(String modoTema);
  Future<void> guardarUbicacion(Position ubicacion);
  Future<Position> buscarUbicacionManual(String direccion);
  Future<List<String>> obtenerSugerencias(String query);
}