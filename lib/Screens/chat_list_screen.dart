import 'package:dental_chat/Screens/user_selection_screen.dart';
import 'package:dental_chat/constants.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:dental_chat/services/chat_stream.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_adding_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/components/chat_tile.dart';

import 'chat_screen.dart';

User loggedInUser;
List<ChatTile> chatTileList = [];

class ChatListScreen extends StatefulWidget {
  ChatListScreen({@required this.chatList});
  final chatList;
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final _auth = FirebaseAuth.instance;
  final _fireStore = FirebaseFirestore.instance;

  String userName;
  String email;
  String userType;
  List<String> sharedprefsList = ['Our  Agent'];
  bool isChanged = false;

  @override
  void initState() {
    sharedprefsList = widget.chatList;
    getCurrentUser(sharedprefsList);
    super.initState();
  }

  void getUserFromCloud() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void getCurrentUser(List chatList) async {
    try {
      userName = await LocalUserData.getUserNameKey();
      email = await LocalUserData.getUserEmailKey();
      userType = await LocalUserData.getUserTypeKey();
      //print(chatList);
      for (int i = 0; i < chatList.length; i++) {
        final chatTile = ChatTile(receiver: chatList[i], loggedInUser: email);
        chatTileList.add(chatTile);
        //print(chatTileList);
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  chatTileBuilder(List chatList) {
    //print(chatList);
    return ListView.builder(
      shrinkWrap: true,
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        return chatList[index];
      },
    );
  }

  saveChat(List prefChat) async {
    //print('hi');
    //print(prefChat);
    await LocalUserData.saveChatList(prefChat);
  }

  /*chatStream() {
    //final chatId =
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('chatRoom')
          .where('user_2', isEqualTo: email)
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        List<ChatTile> chatList = [];
        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          );
        }
        final chats = snapshot.data.docs;

        for (var chat in chats) {
          final user1 = chat['user_1'];
          final messageType = chat['messageType'];
          if (messageType == 'creation') {
            continue;
          } else if (messageType == 'first') {
            for (int i = 0; i < sharedprefsList.length; i++) {
              if (user1 == sharedprefsList[i]) {
                sharedprefsList.remove(user1);
                sharedprefsList.add(user1);
                isChanged = true;
              }
            }
            if (isChanged == false) {
              sharedprefsList.add(user1);
            }
          }
        }
        //sharedprefsList = sharedprefsList;
        saveChat(sharedprefsList);

        for (int i = 0; i < sharedprefsList.length; i++) {
          final chatTile = ChatTile(
            receiver: sharedprefsList[i],
            loggedInUser: email,
            notification: true,
          );
          chatList.add(
            chatTile,
          );
        }
        return Expanded(
          child: ListView(
            children: chatList,
          ),
        );
      },
    );
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset('images/logo.png'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.exit_to_app_sharp),
              onPressed: () async {
                await LocalUserData.saveLoggedInKey(false);
                await LocalUserData.saveChatList([]);
                _auth.signOut();
                await _fireStore
                    .collection('chatList')
                    .doc(email)
                    .set({'chatList': sharedprefsList});
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserSelectionScreen(),
                  ),
                );
              }),
        ],
        title: Text(kAppTitle),
        backgroundColor: Colors.lightBlueAccent,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_comment),
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          //print(email);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatAddingScreen(
                loggedInUser: email,
                newChatCallBack: (newChat) {
                  print('hi');
                  final chatId =
                      ChatRoomGenerator.getChatRoomId(a: newChat, b: email);
                  final users =
                      ChatRoomGenerator.getChatRoomUsers(a: newChat, b: email);
                  _fireStore.collection('chatRoom').doc(chatId).set({
                    'chatId': chatId,
                    'user_1': users[0],
                    'user_2': users[1],
                    'messageType': 'creation',
                  });
                  _fireStore
                      .collection('chatList')
                      .doc(newChat)
                      .update({'newChat': newChat});
                  bool isChanged = false;
                  for (int i = 0; i < sharedprefsList.length; i++) {
                    //print();
                    if (newChat == sharedprefsList[i]) {
                      print('hii');
                      sharedprefsList.remove(newChat);
                      sharedprefsList.add(newChat);
                      isChanged = true;
                    }
                  }
                  if (isChanged == false) {
                    sharedprefsList.add(newChat);
                  }
                  print('hello');
                  print(sharedprefsList);
                  saveChat(sharedprefsList);

                  //print(chatTileList);
                  setState(() {
                    chatTileList.add(ChatTile(
                      receiver: newChat,
                      loggedInUser: email,
                      notification: false,
                    ));
                    Navigator.pop(context);
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        receiver: newChat,
                        chatId: chatId,
                        loggedInUser: email,
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
      body: Container(
        child: Column(
          children: email != null
              ? [
                  ChatStream(
                    loggedInUser: email,
                    sharedprefsList: sharedprefsList,
                    listCallBack: (value) {
                      sharedprefsList = value;
                    },
                  ),
                ]
              : [chatTileBuilder(chatTileList)],
        ),
      ),
    );
  }
}
