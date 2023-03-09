// ignore_for_file: file_names

import 'package:flutter/material.dart';
import "dart:math";
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_to_be/classes/MapsFunctions.dart';
import 'package:places_to_be/pages/PaginaPrincipal.dart';

import '../constants/controllers.dart';
import '../models/maps/Places.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => SideMenuState();
}

class SideMenuState extends State<SideMenu> {
  static const double minValor = 0;
  static const double maxValor = 4;

  static const double minDistance = 0;
  static const double maxDistance = 10;

  double currentMinValuePreco = 0;
  double currentMaxValuePreco = 4;
  double currentValueDistance = 1;

  final List<bool> selectedType = <bool>[false, false, true];

  @override
  Widget build(BuildContext context) {
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
                  buildMenuItem(
                    text: 'Tipo',
                    icon: Icons.question_mark,
                    onClicked: () => itemSelecionado(context, 2),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ToggleButtons(
                        direction: Axis.horizontal,
                        onPressed: (int index) {
                          setState(() {
                            // The button that is tapped is set to true, and the others to false.
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
                  buildFiltroValor(),
                  buildMenuItem(
                    text: 'Filtros Avançados',
                    icon: Icons.more_vert,
                    onClicked: () => itemSelecionado(context, 3),
                  ),
                  buildMenuItem(
                    text: 'Desconectar',
                    icon: Icons.logout,
                    onClicked: () => itemSelecionado(context, 4),
                  ),
                ],
              ),
            ),
            SizedBox(
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
                          onPressed: () => {},
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
                              PaginaPrincipal.goPlace(value);
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
            ),
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
          onClicked: () => itemSelecionado(context, 1),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const buildTextSliderDistancia(value: minDistance),
              Expanded(
                child: Slider(
                  key: const PageStorageKey<String>('valueDistance'),
                  min: minDistance,
                  max: maxDistance,
                  value: currentValueDistance,
                  divisions: maxDistance.toInt(),
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
              const buildTextSliderDistancia(value: maxDistance),
            ],
          ),
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
              const buildTextSliderValor(value: minValor),
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
              const buildTextSliderValor(value: maxValor),
            ],
          ),
        ),
      ],
    );
  }

  Future<Places>? locateRandomPlace() {
    return MapsFunctions.getUserCurrentLocation().then((value) async {
      return MapsFunctions.getPlaces(
        origem: LatLng(value.latitude, value.longitude),
        radius: currentValueDistance.round().toInt() * 1000,
        type: 'restaurant',
        keyword: null,
        minprice: currentMinValuePreco.round().toInt(),
        maxprice: currentMaxValuePreco.round().toInt(),
      ).then((value) {
        final random = Random();
        return value![random.nextInt(value.length)];
      });
    });
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
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
          onTap: onClicked,
        ),
      ],
    );
  }

  itemSelecionado(BuildContext context, int index) {
    switch (index) {
      case 4:
        usuarioController.logout();
        break;
    }
  }
}

class buildTextSliderValor extends StatelessWidget {
  const buildTextSliderValor({
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

class buildTextSliderDistancia extends StatelessWidget {
  const buildTextSliderDistancia({
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
