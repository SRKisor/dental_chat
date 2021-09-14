import 'package:flutter/material.dart';

class ResultTile extends StatelessWidget {
  ResultTile({
    @required this.userName,
    @required this.email,
    @required this.onTap,
  });
  final userName;
  final email;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        color: Colors.grey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                userName,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(email),
            ),
          ],
        ),
      ),
    );
  }
}
