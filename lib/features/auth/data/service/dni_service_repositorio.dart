// En tu capa de infraestructura (infraestructura/servicios/dni_service.dart)
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restaurant_app/features/auth/data/model/dni_service.dart';

class DniService implements IDniService {
  final String baseUrl = 'https://dniruc.apisperu.com/api/v1';
  final String token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJlbWFpbCI6ImpleXNzb25fcy5yQGhvdG1haWwuY29tIn0.VI-ZOrUYeG5IYn7hZQJ-sl2XspnmHPLvoUoQrnRSu_w';
  @override
  Future<DniData> fetchDniData(String dni) async {
    final response =
        await http.get(Uri.parse('$baseUrl/dni/$dni?token=$token'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return DniData(
        dni: json['dni'],
        nombres: json['nombres'],
        apellidoPaterno: json['apellidoPaterno'],
        apellidoMaterno: json['apellidoMaterno'],
      );
    } else {
      throw Exception('Failed to fetch DNI data');
    }
  }
}
