import 'package:dental_chat/Screens/chat_list_screen.dart';
import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:flutter/material.dart';
import 'package:dental_chat/components/rounded_Button.dart';
import 'package:dental_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/helper_function.dart';
import 'chat_screen.dart';

final _fireStore = FirebaseFirestore.instance;

class RegistrationScreen extends StatefulWidget {
  static const id = 'registration_screen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  String email;
  String userName;
  String password;
  String errorMessage = '';
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();


// validating  user input
  validate() {
    if (formKey.currentState.validate()) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  //fit: FlexFit.loose,
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 4
                              ? 'Please Input a valid User Name'
                              : null;
                        },
                        controller: userNameController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          validate();
                          userName = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your User Name'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
                        controller: emailController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          validate();
                          email = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Email Address'),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      TextFormField(
                        validator: (val) {
                          return val.isEmpty || val.length < 6
                              ? 'Please Input a Strong Password with 6+ characters'
                              : null;
                        },
                        textAlign: TextAlign.center,
                        obscureText: true,
                        onChanged: (value) {
                          validate();
                          password = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter Your Password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 24.0,
                ),
                RoundedButton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    print('HI');
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      print('hi');
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      _fireStore.collection('User').add(
                        {
                          'userName': userName,
                          'email': email,
                        },
                      );
                      print('hi');
                      String chatId = ChatRoomGenerator.getChatRoomId(
                          a: 'Our Agent', b: email);
                      List users = ChatRoomGenerator.getChatRoomUsers(
                          a: 'Our Agent', b: email);
                      _fireStore.collection('chatRoom').doc(chatId).set(
                        {
                          'chatId': chatId,
                          'user_1': users[0],
                          'user_2': users[1],
                          'messageType': 'working'
                        },
                      );
                      print('hi');
                      if (newUser != null) {
                        LocalUserData.saveLoggedInKey(true);
                        LocalUserData.saveUserNameKey(userName);
                        LocalUserData.saveUserEmailKey(email);
                        //LocalUserData.saveChatList(['Our Agent']);
                        print('hi');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatListScreen(
                              chatList: ['Our Agent'],
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  title: 'Register',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
