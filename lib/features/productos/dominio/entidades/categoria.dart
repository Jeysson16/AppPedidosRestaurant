class Categoria {
  final String? id;
  final String nombre;

  Categoria({
    this.id,
    required this.nombre
  });

  factory Categoria.fromJson(Map<String, dynamic> json){
    return Categoria(
        id: json["id"],
        nombre: json["nombre"]
      );
  }
  Map<String, dynamic> toJson(){
    return{
      "id": id,
      "nombre": nombre
    };
  }

  Categoria copyWith({
    String? id,
    String? nombre,
    String? descripcion,
  }) {
    return Categoria(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre
    );
  }
}
