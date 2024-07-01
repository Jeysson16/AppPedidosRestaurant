class Variante {
  final String? id;
  final String nombre;
  final double precio;

  Variante({this.id, required this.nombre, required this.precio});

  factory Variante.fromJson(Map<String, dynamic> json) => Variante(
        id: json['id'] as String?,
        nombre: json['nombre'] as String,
        precio: (json['precio'] is int) 
            ? (json['precio'] as int).toDouble()
            : json['precio'] as double,
      );

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'precio': precio,
    };
  }

  Variante copyWith({
    String? id,
    String? nombre,
    double? precio,
  }) {
    return Variante(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      precio: precio ?? this.precio,
    );
  }
}
