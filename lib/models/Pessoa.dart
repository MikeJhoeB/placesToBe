// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class Pessoa {
  final String? id, email;

  Pessoa({
    this.id,
    this.email,
  });

  static Pessoa fromSnapshot(DocumentSnapshot snap) {
    Pessoa pessoa = Pessoa(
      id: snap['id'],
      email: snap['email'],
    );

    return pessoa;
  }
}
