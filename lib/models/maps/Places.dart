import 'package:google_maps_flutter/google_maps_flutter.dart';

class Places {
  final LatLng localizacao;
  final String placeId;

  const Places({
    required this.localizacao,
    required this.placeId,
  });

  factory Places.fromMap(Map<String, dynamic> map) {
    final location = Map<String, dynamic>.from(map['geometry']['location']);

    LatLng localizacao = LatLng(location['lat'], location['lng']);
    String placeId = map['place_id'];

    return Places(
      localizacao: localizacao,
      placeId: placeId,
    );
  }
}

List<Places> getAllPlaces(Map<String, dynamic> map) {
  final data = List<dynamic>.from(map['results']);
  late List<Places> places = [];

  if ((data).isNotEmpty) {
    for (Map<String, dynamic> resultado in data) {
      places.add(Places.fromMap(resultado));
    }
  }

  return places;
}
