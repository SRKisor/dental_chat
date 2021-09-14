import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:flutter/material.dart';
import 'package:dental_chat/components/result_tile.dart';
import 'package:dental_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

final usersRef = FirebaseFirestore.instance.collection('User');
final _firebase = FirebaseFirestore.instance;
//User loggedInUser;

class ChatAddingScreen extends StatefulWidget {
  ChatAddingScreen(
      {@required this.newChatCallBack, @required this.loggedInUser});
  final Function newChatCallBack;
  final loggedInUser;

  @override
  _ChatAddingScreenState createState() => _ChatAddingScreenState();
}

class _ChatAddingScreenState extends State<ChatAddingScreen> {
  List<Widget> resultList = [];
  List<Widget> results = [];

  String receiver;
  String searchedText;
  String chatId;
  bool canShow = false;

  fetchUsers(String search) async {
    await usersRef
        .where('userName', isEqualTo: search)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (widget.loggedInUser != doc['email']) {
          results.add(
            ResultTile(
              userName: doc["userName"],
              email: doc['email'],
              onTap: () {
                widget.newChatCallBack(doc['email']);
              },
            ),
          );
        }
      });
    });
    setState(() {
      resultList = results;
    });
    //for (int i = 0; i < results.length; i++) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color(0xff757575),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                ),
                child: Text(
                  'Add Chat',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          searchedText = value;
                        },
                        decoration: kTextFieldDecoration.copyWith(
                            hintText: 'Enter User name'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(
                          () {
                            results = [];
                            receiver = searchedText;
                            fetchUsers(receiver);
                            canShow = true;
                          },
                        );
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.search),
                      ),
                    ),
                  ),
                ],
              ),
              ListView(
                shrinkWrap: true,
                children: resultList,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
