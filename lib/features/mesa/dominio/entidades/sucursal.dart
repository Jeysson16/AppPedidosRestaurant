import 'package:cloud_firestore/cloud_firestore.dart';

class Sucursal {
  final String? id;
  final String nombreSucursal;
  final int cantidadPisos;
  final String direccion;
  final String estado;
  final String telefono;
  final GeoPoint ubicacion;

  Sucursal({
    this.id,
    required this.nombreSucursal,
    required this.cantidadPisos,
    required this.direccion,
    required this.estado,
    required this.telefono,
    required this.ubicacion
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
    };
  }
}