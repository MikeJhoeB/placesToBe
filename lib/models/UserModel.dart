// ignore_for_file: file_names
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? id, email;

  UserModel({
    this.id,
    this.email,
  });

  static UserModel fromSnapshot(DocumentSnapshot snap) {
    UserModel user = UserModel(
      id: snap['id'],
      email: snap['email'],
    );

    return user;
  }
}
