class Empleado {
  final String? id;
  final String celular;
  final String nombres;
  final String apellidos;
  final String correo;
  final String salarioBase;
  final String edad;
  final String dni;

  Empleado({
    this.id,
    required this.celular,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.salarioBase,
    required this.edad,
    required this.dni,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'celular': celular,
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'salarioBase': salarioBase,
      'edad': edad,
      'dni': dni,
    };
  }

  static Empleado fromJson(Map<String, dynamic> json) {
    return Empleado(
      id: json['id'],
      celular: json['celular'],
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      salarioBase: json['salarioBase'],
      edad: json['edad'],
      dni: json['dni'],
    );
  }
}