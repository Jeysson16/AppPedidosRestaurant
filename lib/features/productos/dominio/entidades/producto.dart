import 'package:restaurant_app/features/productos/dominio/entidades/tamano.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/variante.dart';
import 'package:restaurant_app/features/productos/dominio/entidades/agregado.dart';

class Producto {
  final String? id;
  final String nombre;
  final double precio;
  final double? promocion;
  final String? imagenPrincipal;
  final List<String>? galeria;
  final List<Tamano>? tamanos;
  final List<Variante>? variantes;
  final List<Agregado>? agregados;
  final String descripcion;

  Producto({
    this.id,
    required this.nombre,
    required this.precio,
    this.promocion,
    this.imagenPrincipal,
    this.galeria,
    this.tamanos,
    this.variantes,
    this.agregados,
    required this.descripcion,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json["id"] as String?,
      nombre: json["nombre"],
      precio: json["precio"] as double,
      promocion: json["promocion"] as double?,
      imagenPrincipal: json["imagenPrincipal"] as String?,
      galeria:
          json["galeria"] == null ? null : List<String>.from(json["galeria"]),
      descripcion: json["descripcion"] as String,
      tamanos: json["tamanos"] == null
          ? null
          : (json["tamanos"] as List).map((x) => Tamano.fromJson(x)).toList(),
      variantes: json["variantes"] == null
          ? null
          : (json["variantes"] as List)
              .map((x) => Variante.fromJson(x))
              .toList(),
      agregados: json["agregados"] == null
          ? null
          : (json["agregados"] as List)
              .map((x) => Agregado.fromJson(x))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "nombre": nombre,
      "imagenPrincipal": imagenPrincipal,
      "galeria": galeria,
      "descripcion": descripcion,
      "precio": precio,
      "promocion": promocion,
      "tamanos": tamanos?.map((x) => x.toJson()).toList(),
      "variantes": variantes?.map((x) => x.toJson()).toList(),
      "agregados": agregados?.map((x) => x.toJson()).toList(),
    };
  }

  Producto copyWith({
    String? id,
    String? nombre,
    double? precio,
    double? promocion,
    String? descripcion,
    String? imagenPrincipal,
    List<String>? galeria,
    List<Tamano>? tamanos,
    List<Variante>? variantes,
    List<Agregado>? agregados,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      promocion: promocion ?? this.promocion,
      descripcion: descripcion ?? this.descripcion,
      imagenPrincipal: imagenPrincipal ?? this.imagenPrincipal,
      galeria: galeria ?? this.galeria,
      tamanos: tamanos ?? this.tamanos,
      variantes: variantes ?? this.variantes,
      agregados: agregados ?? this.agregados,
    );
  }
}
