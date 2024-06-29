import 'package:restaurant_app/features/pedidos/dominio/entidades/detalle.dart';
import 'package:restaurant_app/features/pedidos/dominio/entidades/empleado_referenciado.dart';

class Pedido {
  final String? id;
  final String descripcion;
  final double precio;
  final DateTime horaInicioServicio;
  final DateTime? horaFinServicio;
  final bool esDelivery;
  final String? latitud;
  final String? longitud;
  final List<DetallePedido>? detalles;
  final List<EmpleadoReferenciado>? empleados;

  Pedido({
    this.id,
    required this.descripcion,
    required this.precio,
    required this.horaInicioServicio,
    this.horaFinServicio,
    this.detalles,
    this.empleados,
    required this.esDelivery, this.latitud, this.longitud,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'precio': precio,
      'horaInicioServicio': horaInicioServicio.toIso8601String(),
      'horaFinServicio': horaFinServicio?.toIso8601String(),
      'detalles': detalles?.map((detalle) => detalle.toJson()).toList(),
      'empleados': empleados?.map((empleado) => empleado.toJson()).toList(),
    };
  }

  static Pedido fromJson(Map<String, dynamic> json) {
    return Pedido(
      id: json['id'],
      descripcion: json['descripcion'],
      precio: json['precio'],
      esDelivery: json['esDelivery'],
      latitud: json['latitud'],
      longitud: json['longitud'],
      horaInicioServicio: DateTime.parse(json['horaInicioServicio']),
      horaFinServicio: json['horaFinServicio'] != null ? DateTime.parse(json['horaFinServicio']) : null,
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
    DateTime? horaInicioServicio,
    DateTime? horaFinServicio,
    List<DetallePedido>? detalles,
  }) {
    return Pedido(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      precio: precio ?? this.precio,
      esDelivery: esDelivery ?? this.esDelivery,
      latitud: latitud ?? this.latitud,
      longitud: longitud ?? this.longitud,
      horaInicioServicio: horaInicioServicio ?? this.horaInicioServicio,
      horaFinServicio: horaFinServicio ?? this.horaFinServicio,
      detalles: detalles ?? this.detalles,
    );
  }
}