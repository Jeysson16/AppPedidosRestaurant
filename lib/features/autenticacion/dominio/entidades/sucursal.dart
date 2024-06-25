class Sucursal {
  final String? id;
  final String nombreSucursal;
  final int cantidadPisos;
  final String direccion;
  final String estado;
  final String telefono;
  final double latitude; // Nueva propiedad
  final double longitude; // Nueva propiedad

  Sucursal({
    this.id,
    required this.nombreSucursal,
    required this.cantidadPisos,
    required this.direccion,
    required this.estado,
    required this.telefono,
    required this.latitude, // Inicializar propiedad
    required this.longitude, // Inicializar propiedad
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as String?,
      nombreSucursal: json['nombreSucursal'],
      cantidadPisos: json['cantidadPisos'],
      direccion: json['direccion'],
      estado: json['estado'],
      telefono: json['telefono'],
      latitude: json['latitude'], // Asignar propiedad
      longitude: json['longitude'], // Asignar propiedad
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreSucursal': nombreSucursal,
      'cantidadPisos': cantidadPisos,
      'direccion': direccion,
      'estado': estado,
      'telefono': telefono,
      'latitude': latitude, // Incluir propiedad
      'longitude': longitude, // Incluir propiedad
    };
  }
}
