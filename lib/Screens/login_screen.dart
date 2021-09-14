import 'package:flutter/material.dart';
import 'package:dental_chat/components/rounded_Button.dart';
import 'package:dental_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_list_screen.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;
  String userName;

  bool showSpinner = false;
  String email;
  String password;
  String errorMessage = '';
  final textController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> chatList;

  validate() {
    if (formKey.currentState.validate()) {}
  }

  getUserName({@required String email}) async {
    return await FirebaseFirestore.instance
        .collection('User')
        .where('email', isEqualTo: email)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        userName = doc["userName"];
      });
    });
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
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      height: 200.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 22.0,
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        //key: ,
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Enter correct email";
                        },
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
                        controller: textController,
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
                  height: 8.0,
                ),
                Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        await _auth.sendPasswordResetEmail(
                          email: email,
                        );
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: Container(
                      child: Text('Forget Password'),
                    ),
                  ),
                ),
                RoundedButton(
                  color: Colors.lightBlueAccent,
                  onPressed: () async {
                    List<String> finalChatList = [];
                    await _fireStore
                        .collection('chatList')
                        .doc(email)
                        .get()
                        .then(
                      (value) {
                        print(value['chatList']);
                        for (String chat in value['chatList']) {
                          finalChatList.add(chat);
                        }
                        print(finalChatList);
                      },
                    );
                    print(finalChatList);
                    setState(
                      () {
                        textController.clear();
                      },
                    );
                    try {
                      setState(() {
                        showSpinner = true;
                      });
                      final newUser = await _auth.signInWithEmailAndPassword(
                          email: email, password: password);
                      setState(() {
                        showSpinner = true;
                      });
                      if (newUser != null) {
                        LocalUserData.saveLoggedInKey(true);
                        await getUserName(email: email);
                        LocalUserData.saveUserNameKey(userName);
                        LocalUserData.saveUserEmailKey(email);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatListScreen(
                              chatList: finalChatList,
                            ),
                          ),
                        );
                      }
                    } catch (e) {
                      setState(() {
                        errorMessage = '!! Invalid Email or Password';
                      });
                      print(e);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                  title: 'Log in',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
