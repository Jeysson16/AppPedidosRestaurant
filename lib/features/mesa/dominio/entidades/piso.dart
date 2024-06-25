import 'package:restaurant_app/features/mesa/dominio/entidades/mesa.dart';

class  Piso {
  final String? id;
  final int cantidadMesas;
  final String descripcion;
  final String nombre;
  final int numero;
  final List<Mesa>? mesas;

  Piso ({
    this.id,
    required this.cantidadMesas,
    required this.descripcion,
    required this.nombre,
    required this.numero,
    this.mesas,
  });
  factory Piso.fromJson(Map<String, dynamic> json){
    return Piso(
      id: json['id'],
      cantidadMesas: json['cantidadMesas'],
      descripcion: json['descripcion'],
      nombre: json['nombre'],
      numero: json['numero'],
      mesas: json["mesas"] == null
            ? null
            : List<Mesa>.from(
                json["mesas"].map((x) => Mesa.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cantidadMesas': cantidadMesas,
      'descripcion': descripcion,
      'nombre': nombre,
      'numero': numero,
      'mesas': mesas?.map((x) => x.toJson()).toList(),
    };
  }

}
