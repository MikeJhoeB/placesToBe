import 'dart:math';

import 'package:google_maps_flutter/google_maps_flutter.dart';

class Places {
  final LatLng location;
  final String id;
  final String name;
  final int price;
  final double rating;

  const Places({
    required this.location,
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
  });

  factory Places.fromMap(Map<String, dynamic> map) {
    final place = Map<String, dynamic>.from(map['geometry']['location']);

    LatLng location = LatLng(place['lat'], place['lng']);
    String placeId = map['place_id'];
    String name = map['name'];
    int price = map['price_level'];
    double rating = map['rating'];

    return Places(
      location: location,
      id: placeId,
      name: name,
      price: price,
      rating: rating,
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
