import 'package:dental_chat/new_screens/user_selection_screen.dart';
import 'package:flutter/material.dart';

class Alert extends StatelessWidget {
  const Alert({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('No User Found!'),
      content: Text('Do you want to log in?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => UserSelectionScreen()));
          },
          child: Text('Log In'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomeScreen(
                          email: email,
                          userName: userName,
                        )));*/
          },
          child: Text('Cancel'),
        ),
      ],
      elevation: 20,
    );
  }
}
