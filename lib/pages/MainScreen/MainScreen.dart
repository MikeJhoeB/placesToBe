import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../classes/Categorys.dart';
import '../../classes/MapsFunctions.dart';
import '../../constants/controllers.dart';
import '../../models/maps/Places.dart';
import 'Widgets/BuildTextSlider.dart';
import 'Widgets/Details.dart';
import 'Widgets/LoadingUserLocation.dart';
import 'Widgets/MenuItem.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  MapType _currentMapType = MapType.normal;

  final Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  double latUser = 0.0, lngUser = 0.0;
  late CameraPosition inicio;

  static const double minPrice = 0;
  static const double maxPrice = 4;

  static const double minDistance = 0;
  static const double maxDistance = 50;

  double currentMinPrice = 0;
  double currentMaxPrice = 4;
  double currentDistance = 1;

  late final Places placeSorted;

  int indexTypeSelected = 0;
  List<bool> selectedType = <bool>[true, false, false];

  final List<String> placeTypes = <String>["bar", "restaurant", "cafe"];

  double detailPosition = -220;
  String placeName = "Restaurante";
  int placePrice = 0;
  double placeRating = 0;

  final List<Category> _categories = [
    Category('bar', Icons.local_drink),
    Category('restaurant', Icons.restaurant),
    Category('cafe', Icons.coffee),
  ];

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
    return latUser == 0.0 || lngUser == 0.0
        ? const LoadingUserLocation()
        : buildApp();
  }

  Stack buildApp() {
    return Stack(children: [
      Positioned.fill(
        child: Scaffold(
          key: _scaffoldKey,
          drawer: buildSideMenu(context),
          appBar: buildAppBar(),
          body: buildBody(),
          floatingActionButton: buildButtonChangeMapStyle(),
        ),
      ),
      Details(
        detailPosition: detailPosition,
        categories: _categories,
        indexTypeSelected: indexTypeSelected,
        placeName: placeName,
        placePrice: placePrice,
        placeRating: placeRating,
      )
    ]);
  }

  GoogleMap buildBody() {
    return GoogleMap(
      mapType: _currentMapType,
      initialCameraPosition: inicio,
      markers: Set<Marker>.of(_markers.values),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      zoomControlsEnabled: false,
      onTap: (LatLng loc) {
        setState(() {
          detailPosition = -220;
        });
      },
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
              detailPosition = -220;
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
                userController.logout();
              });
            },
            icon: const Icon(Icons.logout)),
      ],
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
                  buildDistanceFilter(context),
                  buildTypeFilter(context),
                  buildPriceFilter(),
                ],
              ),
            ),
            buildSideMenuButtons(context),
          ],
        ),
      ),
    );
  }

  Column buildDistanceFilter(BuildContext context) {
    return Column(
      children: [
        MenuItem(
          text: 'Distance',
          icon: Icons.directions_car_filled,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BuildTextSlider(price: '${minDistance.round().toString()} km'),
              Expanded(
                child: Slider(
                  key: const PageStorageKey<String>('valueDistance'),
                  min: minDistance,
                  max: maxDistance,
                  value: currentDistance,
                  divisions: (maxDistance / 5).round().toInt(),
                  label: currentDistance.round().toString(),
                  inactiveColor: Colors.white,
                  activeColor: Colors.green,
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      currentDistance = value;
                    });
                  },
                ),
              ),
              BuildTextSlider(price: '${maxDistance.round().toString()} km'),
            ],
          ),
        ),
      ],
    );
  }

  Column buildTypeFilter(BuildContext context) {
    return Column(
      children: [
        MenuItem(
          text: 'Type',
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
                Icon(Icons.local_drink),
                Icon(Icons.restaurant),
                Icon(Icons.coffee),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Column buildPriceFilter() {
    return Column(
      children: [
        MenuItem(
          text: 'Price',
          icon: Icons.attach_money_outlined,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              BuildTextSlider(price: minPrice.round().toString()),
              Expanded(
                child: RangeSlider(
                  values:
                      RangeValues(currentMinPrice, currentMaxPrice),
                  min: minPrice,
                  max: maxPrice,
                  inactiveColor: Colors.white,
                  activeColor: Colors.green,
                  divisions: 4,
                  labels: RangeLabels(
                      '$currentMinPrice', '$currentMaxPrice'),
                  onChanged: (value) {
                    setState(() {
                      currentMinPrice = value.start;
                      currentMaxPrice = value.end;
                    });
                  },
                ),
              ),
              BuildTextSlider(price: maxPrice.round().toString()),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox buildSideMenuButtons(BuildContext context) {
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
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () => {cleanFilters()},
                  label: const Text(
                    "Clean",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  icon: const Icon(
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
                child: FloatingActionButton.extended(
                  backgroundColor: Colors.white,
                  onPressed: () async {
                    locateRandomPlace()?.then((value) {
                      if (value != null) {
                        goPlace(value);
                      }
                      Navigator.pop(context);
                    });
                  },
                  label: const Text(
                    "Go",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  icon: const Icon(
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
      return MapsFunctions.getRandomPlace(
        origem: LatLng(value.latitude, value.longitude),
        radius: currentDistance.round().toInt() * 1000,
        type: placeTypes[indexTypeSelected],
        keyword: null,
        minprice: currentMinPrice.round().toInt(),
        maxprice: currentMaxPrice.round().toInt(),
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
        target: place.location,
        tilt: 0,
        zoom: 19.746);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPlace));

    setMarkerAndDetails(place);
  }

  void setMarkerAndDetails(Places place) {
    final MarkerId markerId = MarkerId(place.id);

    final Marker marker = Marker(
        markerId: markerId,
        position: place.location,
        onTap: () {
          setState(() {
            detailPosition = 20;
            placeName = place.name;
            placePrice = place.price;
            placeRating = place.rating;
          });
        });

    setState(() {
      _markers[markerId] = marker;
    });
  }

  void cleanFilters() {
    setState(() {
      currentDistance = 0;
      indexTypeSelected = 0;
      selectedType = <bool>[true, false, false];
      currentMinPrice = 0;
      currentMaxPrice = 4;
    });
  }
}
