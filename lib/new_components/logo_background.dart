import 'package:flutter/material.dart';

class LogoBg extends StatelessWidget {
  LogoBg({this.length});
  final double length;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(25),
      child: Column(
        children: [
          Container(
            width: length,
            height: length,
            decoration: BoxDecoration(
              color: length == 150 ? Colors.blue[200] : Colors.blue[100],
              borderRadius: BorderRadius.circular(25),
              //topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
          ),
          /*Container(
            width: length,
            height: length == 150 ? 59.5 : 44.5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
            ),
          ),*/
        ],
      ),
    );
  }
}
