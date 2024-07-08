class Usuario {
  final String nombres;
  final String apellidos;
  final String correo;
  final String dni;
  final bool? esInvitado;

  Usuario({
    this.esInvitado,
    required this.nombres,
    required this.apellidos,
    required this.correo,
    required this.dni,
  });

  Map<String, dynamic> toJson() {
    return {
      'nombres': nombres,
      'apellidos': apellidos,
      'correo': correo,
      'dni': dni,
    };
  }

  static Usuario fromJson(Map<String, dynamic> json) {
    return Usuario(
      nombres: json['nombres'],
      apellidos: json['apellidos'],
      correo: json['correo'],
      dni: json['dni'],
    );
  }
}
