class Variante {
  final String? id;
  final String nombre;
  final double precio;

  Variante({this.id, required this.nombre, required this.precio});
  // Crea una nueva instancia de la clase a partir de un mapa JSON.
  factory Variante.fromJson(Map<String, dynamic> json) => Variante(
        id: json['id'] as String?,
        nombre: json['nombre'] as String,
        precio: json['precio'] as double,
      );

  // Convierte el objeto a un mapa JSON.
  Map<String, dynamic> toJson(){
    return{
        'id': id,
        'nombre': nombre,
        'precio': precio,
      };
  }
  // Crea una copia del objeto con los cambios especificados.
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