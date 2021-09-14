import 'package:dental_chat/Screens/welcome_screen.dart';
import 'package:dental_chat/components/user_widget.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:flutter/material.dart';

class UserSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 40),
                child: Text('Are you a'),
              ),
              UserWidget(
                userTypeName: 'Admin',
                userTypeSymbol: 'A',
                onTap: () {
                  LocalUserData.saveLoggedInUserType('admin');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(),
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
                      builder: (context) => WelcomeScreen(),
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
