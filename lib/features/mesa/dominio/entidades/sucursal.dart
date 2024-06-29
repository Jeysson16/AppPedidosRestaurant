import 'package:cloud_firestore/cloud_firestore.dart';

class Sucursal {
  final String? id;
  final String nombreSucursal;
  final int cantidadPisos;
  final String direccion;
  final String estado;
  final String telefono;
  final GeoPoint ubicacion;
  final String horaAtencionAbierto;
  final String horaAtencionCerrado;

  Sucursal({
    this.id,
    required this.nombreSucursal,
    required this.cantidadPisos,
    required this.direccion,
    required this.estado,
    required this.telefono,
    required this.ubicacion,
    required this.horaAtencionCerrado,
    required this.horaAtencionAbierto
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as String?,
      nombreSucursal: json['nombreSucursal'],
      cantidadPisos: (json['cantidadPisos'] is double) 
          ? (json['cantidadPisos'] as double).toInt()
          : json['cantidadPisos'] as int,
      direccion: json['direccion'],
      estado: json['estado'],
      telefono: json['telefono'],
      ubicacion: json['ubicacion'],
      horaAtencionAbierto: json['horaAtencionAbierto'],
      horaAtencionCerrado: json['horaAtencionCerrado']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreSucursal': nombreSucursal,
      'cantidadPisos': cantidadPisos,
      'direccion': direccion,
      'estado': estado,
      'telefono': telefono,
      'ubicacion': ubicacion,
      'horaAtencionAbierto': horaAtencionAbierto,
      'horaAtencionCerrado': horaAtencionCerrado
    };
  }
}