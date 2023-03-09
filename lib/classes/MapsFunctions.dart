import 'package:geolocator/geolocator.dart';
import '../models/maps/Distance.dart';
import '../models/maps/Places.dart';
import '../repositorys/maps/Distance.dart';
import '../repositorys/maps/Places.dart';

class MapsFunctions {

  static Future<Distance?> getDistance(origem, destino) async {
    return await DistanceRepository()
        .getDirections(origem: origem, destino: destino);
  }

  static Future<List<Places>?> getPlaces(origem, radius, type, keyword) async {
    return await PlacesRepository().getPlaces(
        origem: origem, radius: radius, type: type, keyword: keyword);
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