import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../constants/keys.dart';
import '../../models/maps/Directions.dart';

class DirectionsRepository {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/directions/json?";

  final Dio _dio = Dio();

  Future<Directions?> getDirections(
      {required LatLng origem, required LatLng destino}) async {
    final response = await _dio.request(_baseUrl, queryParameters: {
      'origin': '${origem.latitude}, ${origem.longitude}',
      'destination': '${destino.latitude}, ${destino.longitude}',
      'key': Keys.keyGoogleAPI,
    });

    if (response.statusCode == 200){
      return Directions.fromMap(response.data);
    }
    return null;
  }
}
