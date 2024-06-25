class Agregado {
  final String? id;
  final String nombre;
  final double precio;

  Agregado({this.id, required this.nombre, required this.precio});
  
  factory Agregado.fromJson(Map<String, dynamic> json) {
    return Agregado(
      id: json['id'] as String?,
      nombre: json['nombre'] as String,
      precio: json['precio'] as double,
      );
  }

  Map<String, dynamic> toJson(){
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
    };
  }

  Agregado copyWith({
    String? id,
    String? nombre,
    double? precio,
  }) {
    return Agregado(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
    );
  }
}
