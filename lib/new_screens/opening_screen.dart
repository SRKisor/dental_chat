import 'package:dental_chat/new_screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../helper_function.dart';

class OpeningScreen extends StatefulWidget {
  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  bool userId = true;
  String email;
  String userName;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    //chatList = await LocalUserData.getChatList();
    userId = await LocalUserData.getUserIdKey();
    email = await LocalUserData.getUserEmailKey();
    userName = await LocalUserData.getUserNameKey();
    print(userId); //todo
    print(email);
    print(userName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset('images/logo.png'),
                      height: 60.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: AnimatedTextKit(
                  onFinished: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(
                          email: email,
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  isRepeatingAnimation: false,
                  animatedTexts: [
                    TyperAnimatedText(
                      'Dental Chat',
                      textStyle: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Kalam',
                          fontWeight: FontWeight.bold),
                      speed: const Duration(seconds: 0, milliseconds: 100),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
