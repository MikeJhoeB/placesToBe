import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/maps/Distance.dart';
import '../repositorys/maps/Distance.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => PaginaPrincipalState();
}

class PaginaPrincipalState extends State<PaginaPrincipal> {

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType _currentMapType = MapType.normal;

  late Distance _info;

  static const CameraPosition _inicio = CameraPosition(
    target: LatLng(-25.36479403367088, -49.18579922601835),
    zoom: 14.4746,
  );

  static const CameraPosition _casa = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-25.34766566118759, -49.202754944489755),
      tilt: 30.440717697143555,
      zoom: 19.151926040649414);

  final List<Marker> _markers = <Marker>[
    const Marker(
      markerId: MarkerId("1"),
      position: LatLng(-25.348509786564463, -49.201286212920394),
      infoWindow: InfoWindow(
        title: 'Casa 1',
      ),
      visible: true,
    ),
    const Marker(
      markerId: MarkerId("2"),
      position: LatLng(-25.34625845594988, -49.20390814776643),
      infoWindow: InfoWindow(
        title: 'Casa 2',
      ),
      visible: true,
    ),
    const Marker(
      markerId: MarkerId("3"),
      position: LatLng(-25.348825633172105, -49.20628447582706),
      infoWindow: InfoWindow(
        title: 'Casa 3',
      ),
      visible: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: _currentMapType,
        initialCameraPosition: _inicio,
        markers: Set<Marker>.of(_markers),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
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
                child: FloatingActionButton(
                  heroTag: 'btn1',
                  onPressed: () async {
                    _getUserCurrentLocation().then((value) async {
                      _getDistance(LatLng(value.latitude, value.longitude),
                              _markers[2].position)
                          .then((value) {
                        if (_info.totalDistance > 300) {
                          _makeMarkerNotVisible(2);
                        }
                      });
                    });
                  },
                  child: const Icon(Icons.search),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: FloatingActionButton(
                  heroTag: 'btn2',
                  onPressed: () => {
                    setState(() {
                      _goHome();
                    })
                  },
                  child: const Icon(Icons.home),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _goHome() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_casa));
  }

  Future<Distance?> _getDistance(origem, destino) async {
    final directions = await DistanceRepository()
        .getDirections(origem: origem, destino: destino);
    setState(() {
      _info = directions!;
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

  void _makeMarkerNotVisible(int markerId) {
    final Marker marker = _markers[markerId];
    setState(() {
      _markers[markerId] = marker.copyWith(
        visibleParam: false,
      );
    });
  }
}
