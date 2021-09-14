import 'package:dental_chat/Screens/chat_screen.dart';
import 'package:dental_chat/Screens/user_selection_screen.dart';
import 'package:dental_chat/Screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../helper_function.dart';
import 'chat_list_screen.dart';

class OpeningScreen extends StatefulWidget {
  @override
  _OpeningScreenState createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  bool userId;
  List<String> chatList;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  getUser() async {
    chatList = await LocalUserData.getChatList();
    userId = await LocalUserData.getUserIdKey();
    print(userId);
    print(chatList);
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
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
              ),
              Expanded(
                child: AnimatedTextKit(
                  onFinished: () {
                    //chatList = ['Our Agent'];
                    print(chatList);
                    userId == true
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChatListScreen(chatList: chatList),
                            ))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserSelectionScreen(),
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
