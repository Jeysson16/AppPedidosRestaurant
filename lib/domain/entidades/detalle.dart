class DetallePedido {
  final String? id;
  final String descripcion;
  final double precioUnitario;
  final int cantidad;
  final double descuento;
  final String? observaciones;

  DetallePedido({
    this.id,
    required this.descripcion,
    required this.precioUnitario,
    required this.cantidad,
    required this.descuento,
    required this.observaciones,
  });
  factory DetallePedido.fromJson(Map<String, dynamic> json) {
    return DetallePedido(
      id: json['id'] as String?,
      descripcion: json['descripcion'],
      precioUnitario: json['precioUnitario'],
      cantidad: json['cantidad'],
      descuento: json['descuento'],
      observaciones: json['observaciones'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'descuento': descuento,
      'observaciones': observaciones,
    };
  }

  DetallePedido copyWith({
    String? id,
    String? descripcion,
    double? precioUnitario,
    int? cantidad,
    double? descuento,
    String? observaciones,
  }) {
    return DetallePedido(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      precioUnitario: precioUnitario ?? this.precioUnitario,
      cantidad: cantidad ?? this.cantidad,
      descuento: descuento ?? this.descuento,
      observaciones: observaciones ?? this.observaciones,
    );
  }
}