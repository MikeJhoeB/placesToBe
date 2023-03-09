// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/controllers.dart';

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
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
                    text: 'Minhas Receitas',
                    icon: Icons.book,
                    onClicked: () => itemSelecionado(context, 3),
                  ),buildMenuItem(
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
                          heroTag: 'btn4',
                          onPressed: () => {

                          },
                          child: const Icon(Icons.search, color: Colors.blueAccent,),
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
                          heroTag: 'btn4',
                          onPressed: () => {

                          },
                          child: const Icon(Icons.search, color: Colors.blueAccent,),
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

  itemSelecionado(BuildContext context, int index) {
    switch (index) {
      case 4:
        usuarioController.logout();
        break;
    }
  }
}
