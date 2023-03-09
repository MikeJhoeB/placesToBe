import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_to_be/widgets/SideMenu.dart';

import '../models/maps/Places.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => PaginaPrincipalState();

  static final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static Future goPlace(Places place) async {
    CameraPosition cameraPlace = CameraPosition(
        bearing: 192.8334901395799,
        target: place.localizacao,
        tilt: 30.440717697143555,
        zoom: 19.151926040649414);

    final GoogleMapController controller = await _controller.future;
    controller.moveCamera(CameraUpdate.newCameraPosition(cameraPlace));
  }
}

class PaginaPrincipalState extends State<PaginaPrincipal> {

  MapType _currentMapType = MapType.normal;

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
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: false,
        compassEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          PaginaPrincipal._controller.complete(controller);
        },
      ),
      floatingActionButton: Builder(
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.only(left: 24.0),
            child: Container(
              alignment: AlignmentDirectional.bottomStart,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: 40,
                      child: FittedBox(
                        child: FloatingActionButton(
                          heroTag: 'openSideMenu',
                          onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                          child: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: SizedBox(
                      height: 40,
                      child: FittedBox(
                        child: FloatingActionButton(
                          heroTag: 'changeMapType',
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
          );
        }
      ),
    );
  }
}
