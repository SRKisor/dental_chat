import 'package:dental_chat/new_screens/advertisement_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseStorage _storage = FirebaseStorage.instance;

class AdvertisementTile extends StatelessWidget {
  AdvertisementTile({@required this.image});
  final image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdvertisementScreen(image: image),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        elevation: 5,
        child: Image.asset(image),
      ),
    );
  }
}
