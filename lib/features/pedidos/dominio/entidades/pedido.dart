import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/empleado_referenciado.dart';
import 'package:flutter/foundation.dart';

class Pedido {
  final String? id;
  final String descripcion;
  final double precio;
  final DateTime horaInicioServicio;
  final DateTime? horaFinServicio;
  final bool esDelivery;
  final String? latitud;
  final String? longitud;
  final String? sucursalId;
  final String? pisoId;
  final String? mesaId;
  final DateTime? fechaReserva;

  final List<DetallePedido>? detalles;
  final List<EmpleadoReferenciado>? empleados;

  Pedido({
    this.id,
    required this.descripcion,
    required this.precio,
    required this.horaInicioServicio,
    this.horaFinServicio,
    required this.esDelivery,
    this.latitud,
    this.longitud,
    this.sucursalId,
    this.pisoId,
    this.mesaId,
    this.fechaReserva,
    this.detalles,
    this.empleados,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'precio': precio,
      'horaInicioServicio': horaInicioServicio.toIso8601String(),
      'horaFinServicio': horaFinServicio?.toIso8601String(),
      'esDelivery': esDelivery,
      'latitud': latitud,
      'longitud': longitud,
      'sucursalId': sucursalId,
      'pisoId': pisoId,
      'mesaId': mesaId,
      'fechaReserva': fechaReserva?.toIso8601String(),
      'detalles': detalles?.map((detalle) => detalle.toJson()).toList(),
      'empleados': empleados?.map((empleado) => empleado.toJson()).toList(),
    };
  }

  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      descripcion: json['descripcion'],
      precio: json['precio'],
      horaInicioServicio: DateTime.parse(json['horaInicioServicio']),
      horaFinServicio: json['horaFinServicio'] != null ? DateTime.parse(json['horaFinServicio']) : null,
      esDelivery: json['esDelivery'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      sucursalId: json['sucursalId'],
      pisoId: json['pisoId'],
      mesaId: json['mesaId'],
      fechaReserva: json['fechaReserva'] != null ? DateTime.parse(json['fechaReserva']) : null,
      detalles: (json['detalles'] as List?)?.map((e) => DetallePedido.fromJson(e)).toList(),
      empleados: (json['empleados'] as List?)?.map((e) => EmpleadoReferenciado.fromJson(e)).toList(),
    );
  }

  Pedido copyWith({
    String? id,
    String? descripcion,
    double? precio,
    bool? esDelivery,
    String? latitud,
    String? longitud,
    String? sucursalId,
    String? pisoId,
    String? mesaId,
    DateTime? horaInicioServicio,
    DateTime? horaFinServicio,
    DateTime? fechaReserva,
    List<DetallePedido>? detalles,
    List<EmpleadoReferenciado>? empleados,
  }) {
    return Pedido(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      esDelivery: esDelivery ?? this.esDelivery,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      sucursalId: sucursalId ?? this.sucursalId,
      pisoId: pisoId ?? this.pisoId,
      mesaId: mesaId ?? this.mesaId,
      horaInicioServicio: horaInicioServicio ?? this.horaInicioServicio,
      horaFinServicio: horaFinServicio ?? this.horaFinServicio,
      fechaReserva: fechaReserva ?? this.fechaReserva,
      detalles: detalles ?? this.detalles,
      empleados: empleados ?? this.empleados,
    );
  }
}
