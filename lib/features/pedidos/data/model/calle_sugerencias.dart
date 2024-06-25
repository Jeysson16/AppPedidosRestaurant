class AddressSuggestion {
  final String fullAddress;
  final String descripcion;
  final String featureType;
  final double latitude;
  final double longitude;

  AddressSuggestion({
    required this.fullAddress,
    required this.descripcion,
    required this.featureType,
    required this.latitude,
    required this.longitude,
  });

  factory AddressSuggestion.fromJson(Map<String, dynamic> json) {
    return AddressSuggestion(
      fullAddress: json['properties']['name_preferred'] ?? '',
      featureType: json['properties']['feature_type'] ?? '',
      descripcion: json['properties']['context']['place']['name']+', '+json['properties']['context']['region']['name']+', '+json['properties']['context']['country']['name'],
      latitude: json['geometry']['coordinates'][1],
      longitude: json['geometry']['coordinates'][0],
    );
  }
}

