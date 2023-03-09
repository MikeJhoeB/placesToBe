// ignore_for_file: file_names

import 'package:flutter/material.dart';
import "dart:math";
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:places_to_be/classes/MapsFunctions.dart';
import 'package:places_to_be/pages/PaginaPrincipal.dart';

import '../constants/controllers.dart';
import '../models/maps/Places.dart';

class SideMenu extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const SideMenu({super.key});

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
                  buildMenuItem(
                    text: 'Distância',
                    icon: Icons.directions_car_filled,
                    onClicked: () => itemSelecionado(context, 1),
                  ),
                  buildMenuItem(
                    text: 'Tipo',
                    icon: Icons.question_mark,
                    onClicked: () => itemSelecionado(context, 2),
                  ),
                  buildMenuItem(
                    text: 'Valor',
                    icon: Icons.attach_money_outlined,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
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
                          onPressed: () => {

                          },
                          child: const Icon(Icons.clear, color: Colors.blueAccent,),
                        ),
                      ),
                    ),
                  ),Padding(
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
                          child: const Icon(Icons.question_mark, color: Colors.blueAccent,),
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

  Future<Places>? locateRandomPlace() {
    return MapsFunctions.getUserCurrentLocation().then((value) async {
      return MapsFunctions.getPlaces(LatLng(value.latitude, value.longitude), 500,
          'restaurant', '').then((value) {

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
