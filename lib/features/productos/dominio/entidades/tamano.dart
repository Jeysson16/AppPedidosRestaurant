class Tamano {
  final String? id;
  final String nombre;
  final double precio;

  Tamano({this.id, required this.nombre, required this.precio});

  factory Tamano.fromJson(Map<String, dynamic> json){
    return Tamano(
      id: json['id'] as String?,
      nombre: json['nombre'] as String,
      precio: json['precio'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
    };
  }

  Tamano copyWith({
    String? id,
    String? nombre,
    double? precio,
  }) {
    return Tamano(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
    );
  }

}