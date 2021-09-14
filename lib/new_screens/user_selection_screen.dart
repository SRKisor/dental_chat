import 'package:dental_chat/components/user_widget.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:dental_chat/new_screens/login_screen.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.blue[400],
              Colors.blue[900],
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text(
                  'Are you a',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              UserWidget(
                userTypeName: 'Admin',
                userTypeSymbol: 'A',
                onTap: () {
                  LocalUserData.saveLoggedInUserType('admin');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
              UserWidget(
                userTypeName: 'User',
                userTypeSymbol: 'U',
                onTap: () {
                  LocalUserData.saveLoggedInUserType('user');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
