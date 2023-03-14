import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../classes/MapsFunctions.dart';
import '../constants/controllers.dart';
import '../models/maps/Places.dart';

class PaginaPrincipal extends StatefulWidget {
  const PaginaPrincipal({Key? key}) : super(key: key);

  @override
  State<PaginaPrincipal> createState() => PaginaPrincipalState();
}

class PaginaPrincipalState extends State<PaginaPrincipal> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType _currentMapType = MapType.normal;

  double latUser = 0.0, lngUser = 0.0;
  late CameraPosition inicio;

  static const double minValor = 0;
  static const double maxValor = 4;

  static const double minDistance = 0;
  static const double maxDistance = 50;

  double currentMinValuePreco = 0;
  double currentMaxValuePreco = 4;
  double currentValueDistance = 1;

  late final Places placeSorted;

  int indexTypeSelected = 0;
  List<bool> selectedType = <bool>[true, false, false];

  final List<String> placeTypes = <String>["bar", "restaurant", "cafe"];

  @override
  initState() {
    super.initState();
    createCameraPosition();
  }

  void createCameraPosition() async {
    MapsFunctions.getUserCurrentLocation().then((value) {
      latUser = value.latitude;
      lngUser = value.longitude;
      setState(() {
        inicio = CameraPosition(
          target: LatLng(latUser, lngUser),
          zoom: 14.4746,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return buildTela(context);
  }

  Widget buildTela(BuildContext context) {
    return buildWidgetPrincipal(context);
  }

  Widget buildWidgetPrincipal(BuildContext context) {
    return latUser == 0.0 || lngUser == 0.0
        ? buildLoadingUserLocation()
        : buildGoogleMap();
  }

  Scaffold buildGoogleMap() {
    return Scaffold(
      key: _scaffoldKey,
      drawer: buildSideMenu(context),
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildButtonChangeMapStyle(),
    );
  }

  GoogleMap buildBody() {
    return GoogleMap(
      mapType: _currentMapType,
      initialCameraPosition: inicio,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      compassEnabled: true,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            setState(() {
              _scaffoldKey.currentState?.openDrawer();
            });
          },
          icon: const Icon(Icons.search)),
      title: const Text(
        "Places to Be",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      actions: [
        IconButton(
            onPressed: () {
              setState(() {
                usuarioController.logout();
              });
            },
            icon: const Icon(Icons.logout)),
      ],
    );
  }

  Scaffold buildLoadingUserLocation() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              height: 10,
            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  Builder buildButtonChangeMapStyle() {
    return Builder(builder: (context) {
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
    });
  }

  Drawer buildSideMenu(BuildContext context) {
    return Drawer(
      width: context.width * 0.85,
      child: Material(
        color: Colors.blueAccent,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  buildFiltroDistancia(context),
                  buildFiltroTipo(context),
                  buildFiltroValor(),
                ],
              ),
            ),
            buildBotoesSideMenu(context),
          ],
        ),
      ),
    );
  }

  Column buildFiltroDistancia(BuildContext context) {
    return Column(
      children: [
        buildMenuItem(
          text: 'Distância',
          icon: Icons.directions_car_filled,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const BuildTextSliderDistancia(value: minDistance),
              Expanded(
                child: Slider(
                  key: const PageStorageKey<String>('valueDistance'),
                  min: minDistance,
                  max: maxDistance,
                  value: currentValueDistance,
                  divisions: (maxDistance / 5).round().toInt(),
                  label: currentValueDistance.round().toString(),
                  inactiveColor: Colors.white,
                  activeColor: Colors.green,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      currentValueDistance = value;
                    });
                  },
                ),
              ),
              const BuildTextSliderDistancia(value: maxDistance),
            ],
          ),
        ),
      ],
    );
  }

  Column buildFiltroTipo(BuildContext context) {
    return Column(
      children: [
        buildMenuItem(
          text: 'Tipo',
          icon: Icons.question_mark,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ToggleButtons(
              direction: Axis.horizontal,
              onPressed: (int index) {
                setState(() {
                  indexTypeSelected = index;
                  for (int i = 0; i < selectedType.length; i++) {
                    selectedType[i] = i == index;
                  }
                });
              },
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              selectedBorderColor: Colors.blue[700],
              selectedColor: Colors.blueAccent,
              fillColor: Colors.white,
              color: Colors.white,
              isSelected: selectedType,
              children: const [
                Icon(Icons.no_drinks),
                Icon(Icons.restaurant),
                Icon(Icons.coffee),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column buildFiltroValor() {
    return Column(
      children: [
        buildMenuItem(
          text: 'Valor',
          icon: Icons.attach_money_outlined,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const BuildTextSliderValor(value: minValor),
              Expanded(
                child: RangeSlider(
                  values:
                      RangeValues(currentMinValuePreco, currentMaxValuePreco),
                  min: minValor,
                  max: maxValor,
                  inactiveColor: Colors.white,
                  activeColor: Colors.green,
                  divisions: 4,
                  labels: RangeLabels(
                      '$currentMinValuePreco', '$currentMaxValuePreco'),
                  onChanged: (value) {
                    setState(() {
                      currentMinValuePreco = value.start;
                      currentMaxValuePreco = value.end;
                    });
                  },
                ),
              ),
              const BuildTextSliderValor(value: maxValor),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox buildBotoesSideMenu(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 50,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => {limpaFiltros()},
                  child: const Icon(
                    Icons.clear,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: SizedBox(
              height: 50,
              child: FittedBox(
                child: FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    locateRandomPlace()?.then((value) {
                      if (value != null) {
                        goPlace(value);
                      }
                      Navigator.pop(context);
                    });
                  },
                  child: const Icon(
                    Icons.question_mark,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<Places?>? locateRandomPlace() {
    return MapsFunctions.getUserCurrentLocation().then((value) async {
      return MapsFunctions.getPlaces(
        origem: LatLng(value.latitude, value.longitude),
        radius: currentValueDistance.round().toInt() * 1000,
        type: placeTypes[indexTypeSelected],
        keyword: null,
        minprice: currentMinValuePreco.round().toInt(),
        maxprice: currentMaxValuePreco.round().toInt(),
      ).then((value) {
        if (value != null) {
          return value;
        }
        return null;
      });
    });
  }

  Future<void> goPlace(Places place) async {
    CameraPosition cameraPlace = CameraPosition(
        bearing: 192.8334901395799,
        target: place.localizacao,
        tilt: 0,
        zoom: 19.746);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPlace));
  }

  void limpaFiltros() {
    setState(() {
      currentValueDistance = 0;
      indexTypeSelected = 0;
      selectedType = <bool>[true, false, false];
      currentMinValuePreco = 0;
      currentMaxValuePreco = 4;
    });
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
  }) {
    const color = Colors.white;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Divider(
            thickness: 2,
            color: Colors.white70,
          ),
        ),
        ListTile(
          leading: Icon(
            icon,
            color: color,
          ),
          hoverColor: Colors.white70,
          title: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class BuildTextSliderValor extends StatelessWidget {
  const BuildTextSliderValor({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value.round().toString(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}

class BuildTextSliderDistancia extends StatelessWidget {
  const BuildTextSliderDistancia({
    super.key,
    required this.value,
  });

  final double value;

  @override
  Widget build(BuildContext context) {
    return Text(
      '${value.round().toString()} km',
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }
}
