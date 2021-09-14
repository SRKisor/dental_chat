import 'package:flutter/material.dart';
import 'package:dental_chat/constants.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {@required this.color, @required this.onPressed, @required this.title});
  final color;
  final Function onPressed;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(colors: [
              Colors.blue[200],
              Colors.blue[500],
            ], begin: Alignment.centerLeft, end: Alignment.centerRight),
          ),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              title,
              style: TextStyle(color: kButtonTextColour),
            ),
          ),
        ),
      ),
    );
  }
}
