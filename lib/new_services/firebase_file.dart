import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseFile {
  const FirebaseFile(
      {@required this.ref, @required this.name, @required this.url});
  final Reference ref;
  final String name;
  final String url;
}
