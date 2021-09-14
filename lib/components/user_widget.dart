import 'package:flutter/material.dart';

class UserWidget extends StatelessWidget {
  UserWidget(
      {@required this.userTypeName, @required this.userTypeSymbol, this.onTap});
  final userTypeName;
  final userTypeSymbol;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: onTap,
        child: Material(
          color: Colors.blue[200],
          elevation: 5,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: LinearGradient(colors: [
                Colors.blue[100],
                Colors.blue[500],
              ], begin: Alignment.centerLeft, end: Alignment.centerRight),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 25,
                        child: Text(
                          userTypeSymbol,
                          style: TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    elevation: 8,
                    color: Colors.grey[400],
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  userTypeName,
                  style: TextStyle(
                    fontSize: 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
