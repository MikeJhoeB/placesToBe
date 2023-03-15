import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/keys.dart';
import '../../models/maps/Places.dart';

class PlacesRepository {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

  final Dio _dio = Dio();

  Future<Places?> getPlace({
    required LatLng origem,
    required int radius,
    required String type,
    String? keyword,
    int? minprice,
    int? maxprice,
  }) async {
    final response = await _dio.request(_baseUrl, queryParameters: {
      'location': '${origem.latitude}, ${origem.longitude}',
      'radius': '$radius',
      'type': type,
      'minprice': minprice,
      'maxprice': maxprice,
      'opennow': true,
      'keyword': keyword,
      'key': Keys.keyGoogleAPI,
    });

    if (response.statusCode == 200) {
        return getRandomPlace(response.data);
    }
    return null;
  }
}
