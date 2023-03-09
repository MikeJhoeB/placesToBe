import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_to_be/repositorys/maps/Places.dart';
import 'package:places_to_be/widgets/SideMenu.dart';

import '../models/maps/Distance.dart';
import '../models/maps/Places.dart';
import '../repositorys/maps/Distance.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => PaginaPrincipalState();
}

class PaginaPrincipalState extends State<PaginaPrincipal> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MapType _currentMapType = MapType.normal;

  late Distance _infoDistance;
  late List<Places> _infoPlaces;

  static const CameraPosition _inicio = CameraPosition(
    target: LatLng(-25.36479403367088, -49.18579922601835),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideMenu(),
      body: GoogleMap(
        mapType: _currentMapType,
        initialCameraPosition: _inicio,
        markers: Set<Marker>.of(markers.values),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Container(
          alignment: AlignmentDirectional.bottomStart,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 30,
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: 'btn1',
                      onPressed: () async {
                        _getUserCurrentLocation().then((value) async {
                          _getPlaces(LatLng(value.latitude, value.longitude), 10000,
                              'restaurant', '').then((value) {
                            for(Places place in _infoPlaces){
                              _addMarker(place.placeId, place.localizacao);
                            }
                          });
                        });
                      },
                      child: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: SizedBox(
                  height: 30,
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: 'btn2',
                      onPressed: () => {
                        setState(() {
                          _clearMarkers();
                        })
                      },
                      child: const Icon(Icons.clear),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 30,
                  child: FittedBox(
                    child: FloatingActionButton(
                      heroTag: 'btn3',
                      onPressed: () => {
                        setState(() {
                          _currentMapType = (_currentMapType == MapType.normal)
                              ? MapType.satellite
                              : MapType.normal;
                        })
                      },
                      child: const Icon(Icons.layers),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _clearMarkers() async {
    markers.clear();
  }

  Future<Distance?> _getDistance(origem, destino) async {
    final distance = await DistanceRepository()
        .getDirections(origem: origem, destino: destino);
    setState(() {
      _infoDistance = distance!;
    });
    return null;
  }

  Future<Places?> _getPlaces(origem, radius, type, keyword) async {
    final places = await PlacesRepository().getPlaces(
        origem: origem, radius: radius, type: type, keyword: keyword);
    setState(() {
      _infoPlaces = places!;
    });
    return null;
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }

  void _addMarker(String placeId, LatLng location) {
    final MarkerId markerId = MarkerId(placeId);

    final Marker marker = Marker(
      markerId: markerId,
      position: location,
    );

    setState(() {
      markers[markerId] = marker;
    });
  }
}
