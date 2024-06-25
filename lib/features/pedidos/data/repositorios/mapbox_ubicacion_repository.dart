import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:restaurant_app/features/mesa/dominio/entidades/sucursal.dart';
import 'package:restaurant_app/features/pedidos/data/model/calle_sugerencias.dart';
import 'package:restaurant_app/features/pedidos/data/model/feature_ubicacion_modelo.dart';
import 'package:restaurant_app/features/pedidos/dominio/repositorios/ubicacion_repositorio.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UbicacionRepositorioImpl implements UbicacionRepositorio {
  final FirebaseFirestore firestore;
  final String mapboxToken;

  UbicacionRepositorioImpl({required this.firestore, required this.mapboxToken});

  @override
  Future<List<Sucursal>> obtenerSucursales() async {
    QuerySnapshot snapshot = await firestore.collection('sucursales').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Sucursal(
        id: data['id'],
        nombreSucursal: data['nombreSucursal'],
        cantidadPisos: data['cantidadPisos'],
        direccion: data['direccion'],
        estado: data['estado'],
        telefono: data['telefono'],
        ubicacion: data['ubicacion'],
      );
    }).toList();
  }

  @override
  Future<Position> obtenerUbicacionTiempoReal() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Error: Permisos de ubicación denegados');
      }
    }
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  @override
  Future<Position> geocodificarDireccion(String direccion) async {
    final url = 'https://api.mapbox.com/search/geocode/v6/forward?q=$direccion&proximity=ip&access_token=$mapboxToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feature = MapboxFeature.fromJson(data['features'][0]);
      return Position(
        latitude: feature.latitude,
        longitude: feature.longitude,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 1.0,
        altitudeAccuracy: 1.0,
        headingAccuracy: 1.0,
      );
    } else {
      throw Exception('Error al geocodificar la dirección');
    }
  }

  @override
  Future<List<AddressSuggestion>> obtenerSugerencias(String query) async {
  final url = 'https://api.mapbox.com/search/geocode/v6/forward?q=$query&country=pe&language=es&autocomplete=true&access_token=$mapboxToken';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return (data['features'] as List)
        .map((feature) => AddressSuggestion.fromJson(feature))
        .toList();
  } else {
    throw Exception('Error fetching suggestions');
  }
}

  
  @override
  Future<Position> geocodificarCoordenadas(double latitude, double longitude) async {
    final url = 'https://api.mapbox.com/search/geocode/v6/reverse?longitude=$longitude&latitude=$latitude&access_token=$mapboxToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feature = MapboxFeature.fromJson(data['features'][0]);
      return Position(
        latitude: feature.latitude,
        longitude: feature.longitude,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 1.0,
        altitudeAccuracy: 1.0,
        headingAccuracy: 1.0,
      );
    } else {
      throw Exception('Error al geocodificar las coordenadas');
    }
  }

  @override
  double calcularDistancia(Position origen, Position destino) {
    return Geolocator.distanceBetween(
      origen.latitude,
      origen.longitude,
      destino.latitude,
      destino.longitude,
    );
  }

  @override
  double calcularTiempoCaminando(double distancia) {
    double velocidadCaminando = 5; // km/h
    return distancia / velocidadCaminando; // tiempo en horas
  }

  @override
  double calcularTiempoMoto(double distancia) {
    double velocidadMoto = 30; // km/h
    return distancia / velocidadMoto; // tiempo en horas
  }

  @override
  double calcularCobro(double tiempoMoto) {
    if (tiempoMoto > 10) {
      return tiempoMoto * 2; // ejemplo de cobro
    }
    return 0;
  }

  @override
  Future<void> establecerModoTema(String modoTema) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('modoTema', modoTema);
  }

  @override
  Future<String> obtenerModoTema() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('modoTema') ?? 'claro';
  }

  @override
  String obtenerUrlTemplate(String modoTema) {
    return 'https://api.mapbox.com/styles/v1/mapbox/${modoTema == "oscuro" ? "dark-v10" : "light-v10"}/tiles/256/{z}/{x}/{y}@2x?access_token=$mapboxToken';
  }

  @override
  Future<List<Sucursal>> obtenerUbicacionesSucursales() async {
    QuerySnapshot snapshot = await firestore.collection('sucursales').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Sucursal(
        id: data['id'],
        nombreSucursal: data['nombreSucursal'],
        cantidadPisos: data['cantidadPisos'],
        direccion: data['direccion'],
        estado: data['estado'],
        telefono: data['telefono'],
        ubicacion: data['ubicacion'],
      );
    }).toList();
  }

  @override
  Future<Position> buscarUbicacionManual(String direccion) async {
    final url = 'https://api.mapbox.com/geocoding/v5/mapbox.places/$direccion.json?access_token=$mapboxToken';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];
      return Position(
        latitude: coordinates[1],
        longitude: coordinates[0],
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 1.0,
        altitudeAccuracy: 1.0,
        headingAccuracy: 1.0,
      );
    } else {
      throw Exception('Error al buscar la ubicación manualmente');
    }
  }

  @override
  Future<void> guardarUbicacion(Position ubicacion) async {
    final docRef = firestore.collection('ubicaciones').doc();
    await docRef.set({
      'latitude': ubicacion.latitude,
      'longitude': ubicacion.longitude,
      'timestamp': ubicacion.timestamp.toIso8601String(),
      'accuracy': ubicacion.accuracy,
      'altitude': ubicacion.altitude,
      'heading': ubicacion.heading,
      'speed': ubicacion.speed,
      'speedAccuracy': ubicacion.speedAccuracy,
    });
  }
}
