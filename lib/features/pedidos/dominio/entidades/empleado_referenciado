class EmpleadoReferenciado {
  final String id;
  final String nombre;
  final String cargo;

  EmpleadoReferenciado({
    required this.id,
    required this.nombre,
    required this.cargo,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'cargo': cargo,
    };
  }

  static EmpleadoReferenciado fromJson(Map<String, dynamic> json) {
    return EmpleadoReferenciado(
      id: json['id'],
      nombre: json['nombre'],
      cargo: json['cargo'],
    );
  }
}