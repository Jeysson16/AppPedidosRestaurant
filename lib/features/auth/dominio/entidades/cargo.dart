class Cargo {
  final String? id;
  final String descripcion;
  final String nombre;
  final List<String> permisos;
  final String salarioBase;

  Cargo({
    this.id,
    required this.descripcion,
    required this.nombre,
    required this.permisos,
    required this.salarioBase,
  });
  factory Cargo.fromJson(Map<String, dynamic> json) {
    return Cargo(
      id: json["id"],
      descripcion: json["descripcion"],
      nombre: json["nombre"],
      permisos: List<String>.from(json["permisos"].map((x) => x)),
      salarioBase: json["salario_base"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "descripcion": descripcion,
      "nombre": nombre,
      "permisos": List<dynamic>.from(permisos.map((x) => x)),
      "salario_base": salarioBase,
    };
  }

  Cargo copyWith({
    String? id,
    String? descripcion,
    String? nombre,
    List<String>? permisos,
    String? salarioBase,
  }) {
    return Cargo(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      nombre: nombre ?? this.nombre,
      permisos: permisos ?? this.permisos,
      salarioBase: salarioBase ?? this.salarioBase,
    );
  }
}
