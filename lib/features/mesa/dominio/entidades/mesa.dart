class Mesa {
  final String? id;
  final String descripcion;
  final int numero;
  final String estado;

  Mesa({
    this.id,
    required this.descripcion,
    required this.numero,
    required this.estado,
  });

  factory Mesa.fromJson(Map<String, dynamic> json) {
    return Mesa(
      id: json['id'],
      descripcion: json['descripcion'],
      numero: json['numero'],
      estado: json['estado']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'numero': numero,
      'estado': estado
    };

  }

  Mesa copyWith({
    String? id,
    String? descripcion,
    int? numero,
    String? estado
  }){
    return Mesa(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      numero: numero ?? this.numero,
      estado: estado ?? this.estado
    );
  }
}