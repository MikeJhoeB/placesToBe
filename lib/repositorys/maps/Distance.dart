import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/keys.dart';
import '../../models/maps/Distance.dart';


class DistanceRepository {
  static const String _baseUrl =
      "https://maps.googleapis.com/maps/api/distancematrix/json?";

  final Dio _dio = Dio();

  Future<Distance?> getDirections(
      {required LatLng origem, required LatLng destino}) async {
    final response = await _dio.request(_baseUrl, queryParameters: {
      'origins': '${origem.latitude}, ${origem.longitude}',
      'destinations': '${destino.latitude}, ${destino.longitude}',
      'key': Keys.keyGoogleAPI,
    });

    if (response.statusCode == 200){
      return Distance.fromMap(response.data);
    }
    return null;
  }
}
