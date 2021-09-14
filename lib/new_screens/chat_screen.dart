import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:dental_chat/new_services/message_stream.dart';
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
import 'package:intl/intl.dart';

final _fireStore = FirebaseFirestore.instance;

class ChatScreen extends StatefulWidget {
  ChatScreen(
      {this.userType, this.receiver, @required this.chatId, this.loggedInUser});
  final String receiver;
  final String chatId;
  final String loggedInUser;
  final String userType;

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
  User loggedInUser = FirebaseAuth.instance.currentUser;
  String typedMessage;
  final textController = TextEditingController();
  DialogflowGrpcV2Beta1 dialogflow;
  bool showList = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    createAccount();
    getDate();
    getChatInfo();
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

  getDate() {
    String stringDate = '2021-08-08T12:00:00+05:30';
    DateTime date = DateTime.tryParse(stringDate);
    print(date.year);
    print(date.month);
    print(date.day);
    print(date.weekday);
    print(date.hour);
    print(date.minute);
  }

  List dentists = [];

  getChatInfo() async {
    await _fireStore
        .collection('General Info')
        .doc('Dentists Info')
        .get()
        .then((value) {
      dentists = value['dentists'];
    });
    setState(() {});
  }

  List date = [];
  String time;

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
      if (fulfillmentText == 'showDentistList') {
        await _fireStore
            .collection('chatRoom')
            .doc(widget.chatId)
            .collection('chat')
            .add({
          'receiver': email,
          'sender': 'Our Agent',
          'text': 'Please select a doctor for book appointment',
          'date': DateTime.now().toIso8601String().toString(),
        });
        selectedDoctor = null;
        showList = true;
      } else {
        if (fulfillmentText.contains('you all set for an appointment for')) {
          _fireStore
              .collection('chatRoom')
              .doc(widget.chatId)
              .collection('chat')
              .add({
            'receiver': email,
            'sender': 'Our Agent',
            'text':
                'You all set for an appointment for $selectedDoctor on ${date[0]} at $time, See you then!',
            'date': DateTime.now().toIso8601String().toString(),
          });
          _fireStore
              .collection('User')
              .doc(loggedInUser.uid)
              .get()
              .then((value) {
            List appointment = value['appointments'];
            appointment.add({
              'dentistName': selectedDoctor,
              'date': date[0],
              'time': time,
            });
            _fireStore
                .collection('User')
                .doc(loggedInUser.uid)
                .update({'appointments': appointment});
          }).catchError((e) {
            if (e.toString().contains('does not exist')) {
              _fireStore.collection('User').doc(loggedInUser.uid).update({
                'appointments': [
                  {
                    'dentistName': selectedDoctor,
                    'date': date[0],
                    'time': time,
                  }
                ]
              });
            }
          });
        } else {
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
      }
    }
    setState(() {
      isTyping = false;
    });
  }

  String selectedDoctor;

  dropDown(List dropList) {
    List<DropdownMenuItem> dropdownList = [];
    for (Map listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Container(
          width: 200,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Container(
              child: Text(
                listItem['name'],
                style: TextStyle(color: Colors.white),
              ),
            ),
            Container(
              child: Text(
                listItem['description'],
                style: TextStyle(color: Colors.white),
              ),
            ),
            Divider(
              thickness: 1,
              height: 0,
            ),
          ]),
        ),
        value: listItem['name'],
      );
      dropdownList.add(newItem);
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        color: Colors.blue,
        width: 100,
        child: DropdownButton(
          underline: SizedBox(),
          focusColor: Colors.blue,
          hint: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Select a Doctor'),
          ),
          dropdownColor: Colors.blue,
          value: selectedDoctor,
          items: dropdownList,
          onChanged: (value) {
            selectedDoctor = value;
            print(selectedDoctor);
            setState(() {});
          },
        ),
      ),
    );
  }

  saveDoctor() async {
    final users =
        ChatRoomGenerator.getChatRoomUsers(a: widget.receiver, b: email);
    _fireStore.collection('chatRoom').doc(widget.chatId).set({
      'chatId': widget.chatId,
      'user_1': users[0],
      'user_2': users[1],
      'messageType': 'working',
      'message': 'I want to schedule a appointment for $selectedDoctor',
      'time': DateTime.now().toIso8601String().toString(),
    });

    _fireStore
        .collection('chatRoom')
        .doc(widget.chatId)
        .collection('chat')
        .add({
      'receiver': widget.receiver,
      'sender': email,
      'text': 'I want to schedule a appointment for $selectedDoctor',
      'date': DateTime.now().toIso8601String().toString(),
    });

    _fireStore
        .collection('chatRoom')
        .doc(widget.chatId)
        .collection('chat')
        .add({
      'receiver': email,
      'sender': 'Our Agent',
      'text': 'At What time you want to set the appointment',
      'date': DateTime.now().toIso8601String().toString(),
    });
    DateTime selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.parse('2021-01-01'),
      lastDate: DateTime.parse('2025-09-01'),
    );
    var selectedTime = await showTimePicker(
        context: context, initialTime: TimeOfDay(hour: 00, minute: 00));
    date = selectedDate.toString().split(' ');
    String val = selectedTime.toString().replaceAll('TimeOfDay(', '');
    List value = val.replaceAll(')', '').split(':');
    time = int.parse(value[0]) > 12
        ? '${int.parse(value[0]) - 12}.${value[1]} pm'
        : int.parse(value[0]) == 12
            ? '${value[0]}.${value[1]} pm'
            : '${value[0]}.${value[1]} am';

    _fireStore.collection('chatRoom').doc(widget.chatId).set({
      'chatId': widget.chatId,
      'user_1': users[0],
      'user_2': users[1],
      'messageType': 'working',
      'message': 'I want to schedule a appointment on ${date[0]} at $time',
      'time': DateTime.now().toIso8601String().toString(),
    });

    _fireStore
        .collection('chatRoom')
        .doc(widget.chatId)
        .collection('chat')
        .add({
      'receiver': widget.receiver,
      'sender': email,
      'text': 'I want to schedule a appointment on ${date[0]} at $time',
      'date': DateTime.now().toIso8601String().toString(),
    });
    handleSubmitted(
        'I want to schedule a appointment for $selectedDoctor on ${date[0]} at $time');
    showList = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: Text(widget.receiver),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              child: MessagesStream(
                chatId: widget.chatId,
                receiver: widget.receiver,
                loggedInUser: widget.loggedInUser,
              ),
            ),
            Visibility(
              visible: false,
              child: DatePickerDialog(
                initialDate: DateTime.now(),
                firstDate: DateTime.parse('2021-01-01'),
                lastDate: DateTime.parse('2025-09-01'),
              ),
            ),
            Visibility(
              visible: showList,
              child: Container(
                  width: 100,
                  padding: EdgeInsets.only(left: 30, right: 100),
                  child: dropDown(dentists)),
            ),
            Visibility(
              visible: showList,
              child: Center(
                child: Container(
                  width: 100,
                  child: ElevatedButton(
                    onPressed: () {
                      selectedDoctor != null ? saveDoctor() : null;
                    },
                    child: Text('Ok'),
                  ),
                ),
              ),
            ),
            isTyping
                ? TypingTile()
                : SizedBox(
                    height: 20,
                  ),
            Visibility(
              visible: widget.userType == 'User',
              child: Container(
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
                                  'time': DateTime.now()
                                      .toIso8601String()
                                      .toString(),
                                });
                              } else {
                                final users =
                                    ChatRoomGenerator.getChatRoomUsers(
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
                                  'time': DateTime.now()
                                      .toIso8601String()
                                      .toString(),
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
                              'date':
                                  DateTime.now().toIso8601String().toString(),
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
