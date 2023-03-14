import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/maps/Distance.dart';
import '../models/maps/Places.dart';
import '../repositorys/maps/Distance.dart';
import '../repositorys/maps/Places.dart';

class MapsFunctions {
  static Future<Distance?> getDistance(origem, destino) async {
    return await DistanceRepository()
        .getDirections(origem: origem, destino: destino);
  }

  static Future<Places?> getPlaces(
      {required LatLng origem,
      required int radius,
      required String type,
      required String? keyword,
      required int? minprice,
      required int? maxprice}) async {
    return await PlacesRepository().getPlaces(
      origem: origem,
      radius: radius,
      type: type,
      keyword: keyword,
      minprice: minprice,
      maxprice: maxprice,
    );
  }

  static Future<Position> getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }
}
