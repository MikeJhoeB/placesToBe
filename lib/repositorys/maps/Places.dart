import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../models/maps/Places.dart';


class PlacesRepository {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

  final Dio _dio = Dio();

  Future<List<Places>?> getPlaces(
      {required LatLng origem, required int radius, required String type, String? keyword}) async {
    final response = await _dio.request(_baseUrl, queryParameters: {
      'location': '${origem.latitude}, ${origem.longitude}',
      'radius': '$radius',
      'type': type,
      'keyword': keyword,
      'key': 'AIzaSyC1Ype7NJXm3PKyUKOzQvNMSSik_sSBHvQ',
    });

    print(response);

    if (response.statusCode == 200){
      return getAllPlaces(response.data);
    }
    return null;
  }
}
