// En tu capa de dominio (dominio/contratos/idni_service.dart)
abstract class IDniService {
  Future<DniData> fetchDniData(String dni);
}

// Modelo de datos para el DNI
class DniData {
  final String nombres;
  final String apellidoPaterno;
  final String apellidoMaterno;
  final String dni;

  DniData({
    required this.dni,
    required this.nombres,
    required this.apellidoPaterno,
    required this.apellidoMaterno,
  });
}
