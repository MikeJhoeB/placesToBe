import 'package:flutter/material.dart';

Widget MenuItem({
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