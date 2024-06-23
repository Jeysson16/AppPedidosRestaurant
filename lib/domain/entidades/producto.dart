import 'agregado.dart';
import 'tamano.dart';
import 'variante.dart';

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
  });

  factory Producto.fromJson(Map<String, dynamic> json){
    return Producto(
        id: json["id"] as String?,
        nombre: json["nombre"],
        precio: json["precio"] as double,
        promocion: json["promocion"] as double?,
        tamanos: json["tamanos"] == null
            ? null
            : List<Tamano>.from(
                json["tamanos"].map((x) => Tamano.fromJson(x))),
        variantes: json["variantes"] == null
            ? null
            : List<Variante>.from(
                json["variantes"].map((x) => Variante.fromJson(x))),
        agregados: json["agregados"] == null
            ? null
            : List<Agregado>.from(
                json["agregados"].map((x) => Agregado.fromJson(x))),
  );
  }

  Map<String, dynamic> toJson() {
    return {
        "id": id,
        "nombre": nombre,
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
    List<Tamano>? tamanos,
    List<Variante>? variantes,
    List<Agregado>? agregados,
  }) {
    return Producto(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
      promocion: promocion ?? this.promocion,
      tamanos: tamanos ?? this.tamanos,
      variantes: variantes ?? this.variantes,
      agregados: agregados ?? this.agregados,
    );
  }
}