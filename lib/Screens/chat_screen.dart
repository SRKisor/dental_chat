import 'package:dental_chat/components/message_bubble.dart';
import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:dental_chat/services/message_stream.dart';
import 'package:flutter/material.dart';
import 'package:dental_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dialogflow_grpc/v2beta1.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:dental_chat/helper_function.dart';
import 'opening_screen.dart';

final _fireStore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {@required this.receiver,
      @required this.chatId,
      @required this.loggedInUser});
  final String receiver;
  final String chatId;
  final String loggedInUser;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  String userName;
  String email;
  String userType;
  bool isTyping = false;
  String messageType;
  String user1;

  String typedMessage;
  final textController = TextEditingController();
  DialogflowGrpcV2Beta1 dialogflow;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    createAccount();
  }

  void getCurrentUser() async {
    try {
      userName = await LocalUserData.getUserNameKey();
      email = await LocalUserData.getUserEmailKey();
      userType = await LocalUserData.getUserTypeKey();
    } catch (e) {
      print(e);
    }
  }

  Future<void> createAccount() async {
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/service.json'))}');

    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
  }

  void handleSubmitted(text) async {
    setState(() {
      isTyping = true;
    });
    String fulfillmentText = '';
    try {
      DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
      fulfillmentText = data.queryResult.fulfillmentText;
    } catch (e) {
      print(e);
    }

    if (fulfillmentText.isNotEmpty) {
      _fireStore
          .collection('chatRoom')
          .doc(widget.chatId)
          .collection('chat')
          .add({
        'receiver': email,
        'sender': 'Our Agent',
        'text': fulfillmentText,
        'date': DateTime.now().toIso8601String().toString(),
      });
    }
    setState(() {
      isTyping = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(widget.receiver),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await _auth.signOut();
                await LocalUserData.saveLoggedInKey(false);
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => OpeningScreen()));
              }),
        ],
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessagesStream(
              chatId: widget.chatId,
              receiver: widget.receiver,
              loggedInUser: widget.loggedInUser,
            ),
            isTyping
                ? TypingTile()
                : SizedBox(
                    height: 20,
                  ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textController,
                      onChanged: (value) {
                        typedMessage = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                      onPressed: () async {
                        if (textController.text != '') {
                          textController.clear();
                          await _fireStore
                              .collection('chatRoom')
                              .doc(widget.chatId)
                              .get()
                              .then((value) {
                            messageType = value['messageType'];
                            user1 = value['user_1'];
                          });
                          print(messageType);
                          print(user1);
                          print(email);
                          if (messageType == 'creation') {
                            _fireStore
                                .collection('chatRoom')
                                .doc(widget.chatId)
                                .set({
                              'chatId': widget.chatId,
                              'user_1': email,
                              'user_2': widget.receiver,
                              'messageType': 'first',
                              'message': typedMessage,
                              'time':
                                  DateTime.now().toIso8601String().toString(),
                            });
                          } else if (messageType != 'first') {
                            print('hi');
                            if (user1 == email) {
                              _fireStore
                                  .collection('chatRoom')
                                  .doc(widget.chatId)
                                  .set({
                                'chatId': widget.chatId,
                                'user_1': email,
                                'user_2': widget.receiver,
                                'messageType': 'first',
                                'message': typedMessage,
                                'time':
                                    DateTime.now().toIso8601String().toString(),
                              });
                            } else {
                              final users = ChatRoomGenerator.getChatRoomUsers(
                                  a: widget.receiver, b: email);
                              _fireStore
                                  .collection('chatRoom')
                                  .doc(widget.chatId)
                                  .set({
                                'chatId': widget.chatId,
                                'user_1': users[0],
                                'user_2': users[1],
                                'messageType': 'working',
                                'message': typedMessage,
                                'time':
                                    DateTime.now().toIso8601String().toString(),
                              });
                            }
                          } else if (messageType == 'working') {
                            final users = ChatRoomGenerator.getChatRoomUsers(
                                a: widget.receiver, b: email);
                            _fireStore
                                .collection('chatRoom')
                                .doc(widget.chatId)
                                .set({
                              'chatId': widget.chatId,
                              'user_1': users[0],
                              'user_2': users[1],
                              'messageType': 'working',
                              'message': typedMessage,
                              'time':
                                  DateTime.now().toIso8601String().toString(),
                            });
                          }
                          _fireStore
                              .collection('chatRoom')
                              .doc(widget.chatId)
                              .collection('chat')
                              .add({
                            'receiver': widget.receiver,
                            'sender': email,
                            'text': typedMessage,
                            'date': DateTime.now().toIso8601String().toString(),
                          });
                          if (widget.receiver == 'Our Agent') {
                            //print('hi');
                            handleSubmitted(typedMessage);
                          }
                        }
                      },
                      child: Icon(Icons.send_sharp)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypingTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, bottom: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 5,
            //if (isMe == true) {
            color: Colors.grey,
            //}
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
              child: Text(
                'typing ...',
                style: TextStyle(fontSize: 13, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
