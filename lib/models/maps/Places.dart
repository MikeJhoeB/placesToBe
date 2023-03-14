import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Places {
  final LatLng localizacao;
  final String placeId;
  final String name;

  const Places({
    required this.localizacao,
    required this.placeId,
    required this.name,
  });

  factory Places.fromMap(Map<String, dynamic> map) {
    final location = Map<String, dynamic>.from(map['geometry']['location']);

    LatLng localizacao = LatLng(location['lat'], location['lng']);
    String placeId = map['place_id'];
    String name = map['name'];

    return Places(
      localizacao: localizacao,
      placeId: placeId,
      name: name,
    );
  }
}

Places getRandomPlace(Map<String, dynamic> map) {
  late List<Places> places = getAllPlaces(map);

  final random = Random();
  return places[random.nextInt(places.length)];
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
