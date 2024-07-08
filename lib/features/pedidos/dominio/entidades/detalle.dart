import 'dart:math';
import 'dart:ui';

import 'package:restaurant_app/features/productos/dominio/entidades/producto.dart';

class DetallePedido {
  final String? id;
  final String descripcion;
  final Producto producto;
  final double precioUnitario;
  final int cantidad;
  final String estado;
  final double descuento;

  final String? pedidoId;
  final String? observaciones;
  final Color? color;

  static Color _generateRandomColor() {
    Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  DetallePedido(
      {this.id,
      required this.producto,
      required this.descripcion,
      required this.precioUnitario,
      required this.cantidad,
      required this.descuento,
      required this.estado,
      this.pedidoId,
      required this.observaciones,
      this.color});
  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'] as String?,
      descripcion: json['descripcion'],
      precioUnitario: json['precioUnitario'],
      cantidad: json['cantidad'],
      descuento: json['descuento'],
      estado: json['estado'],
      color: _generateRandomColor(),
      observaciones: json['observaciones'],
      pedidoId: json['pedidoId'],
      producto: Producto.fromJson(json['producto'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'descuento': descuento,
      'observaciones': observaciones,
      'estado': estado,
      'producto': producto.toJson()
    };
  }

  DetallePedido copyWith({
    String? id,
    String? descripcion,
    double? precioUnitario,
    int? cantidad,
    double? descuento,
    String? estado,
    String? observaciones,
    String? pedidoId,
    Producto? producto,
  }) {
    return DetallePedido(
      id: id ?? this.id,
      producto: producto ?? this.producto,
      descripcion: descripcion ?? this.descripcion,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidad: cantidad ?? this.cantidad,
      descuento: descuento ?? this.descuento,
      pedidoId: pedidoId ?? this.pedidoId,
      estado: estado ?? this.estado,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}
