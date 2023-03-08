// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/controllers.dart';

class NavigationDrawer extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: context.width * 0.50,
      child: Material(
        color: Colors.green,
        child: ListView(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            buildMenuItem(
              text: 'Meu Perfil',
              icon: Icons.person,
              onClicked: () => itemSelecionado(context, 1),
            ),
            buildMenuItem(
              text: 'Meus Pedidos',
              icon: Icons.shopping_cart,
              onClicked: () => itemSelecionado(context, 2),
            ),
            buildMenuItem(
              text: 'Minhas Receitas',
              icon: Icons.book,
              onClicked: () => itemSelecionado(context, 3),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(
                thickness: 2,
                color: Colors.white70,
              ),
            ),
            buildMenuItem(
              text: 'Desconectar',
              icon: Icons.logout,
              onClicked: () => itemSelecionado(context, 4),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  }) {
    const color = Colors.white;
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      hoverColor: Colors.white70,
      title: Text(
        text,
        style: const TextStyle(
          color: color,
        ),
      ),
      onTap: onClicked,
    );
  }

  itemSelecionado(BuildContext context, int index){
    switch(index){
      case 4:
        usuarioController.logout();
        break;
    }
  }
}
