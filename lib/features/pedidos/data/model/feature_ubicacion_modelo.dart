class MapboxFeature {
  final String id;
  final double longitude;
  final double latitude;
  final String fullAddress;
  final String placeFormatted;

  MapboxFeature({
    required this.id,
    required this.longitude,
    required this.latitude,
    required this.fullAddress,
    required this.placeFormatted,
  });

  factory MapboxFeature.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final properties = json['properties'];

    return MapboxFeature(
      id: json['id'],
      longitude: geometry['coordinates'][0],
      latitude: geometry['coordinates'][1],
      fullAddress: properties['full_address'],
      placeFormatted: properties['place_formatted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'geometry': {
        'coordinates': [longitude, latitude],
      },
      'properties': {
        'full_address': fullAddress,
        'place_formatted': placeFormatted,
      },
    };
  }
}
