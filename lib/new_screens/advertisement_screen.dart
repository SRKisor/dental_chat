import 'package:flutter/material.dart';

class AdvertisementScreen extends StatelessWidget {
  AdvertisementScreen({@required this.image});
  final image;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        color: Colors.grey[900],
        elevation: 5,
        child: Image.network(
          image,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
