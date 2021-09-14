import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/components/chat_tile.dart';

import '../helper_function.dart';

final _fireStore = FirebaseFirestore.instance;

class ChatStream extends StatefulWidget {
  ChatStream({
    @required this.loggedInUser,
    @required this.sharedprefsList,
    @required this.listCallBack,
  });

  final loggedInUser;
  final sharedprefsList;
  final listCallBack;

  @override
  _ChatStreamState createState() => _ChatStreamState();
}

class _ChatStreamState extends State<ChatStream> {
  List<List> newList = [];
  saveChat(List prefChat) async {
    //print('hi');
    //print(prefChat);
    await LocalUserData.saveChatList(prefChat);
  }

  getMessageTime(list) async {
    for (String user in list) {
      if (user != 'OurAgent') {
        final userId =
            ChatRoomGenerator.getChatRoomId(a: user, b: widget.loggedInUser);
        await _fireStore
            .collection('chatRoom')
            .where('userId', isEqualTo: userId)
            .get()
            .then(
          (QuerySnapshot querySnapshot) {
            querySnapshot.docs.forEach(
              (doc) {
                final time = doc['time'];
                newList.add([user, time]);
                print(newList);
              },
            );
          },
        );
        //setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore
          .collection('chatRoom')
          .where('user_2', isEqualTo: widget.loggedInUser)
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
          //final notification = chat['notification'];
          bool isChanged = false;
          if (messageType == 'creation') {
            continue;
          } else if (messageType == 'first') {
            for (int i = 0; i < widget.sharedprefsList.length; i++) {
              if (user1 == widget.sharedprefsList[i]) {
                widget.sharedprefsList.remove(user1);
                widget.sharedprefsList.add(user1);
                isChanged = true;
              }
            }
            if (isChanged == false) {
              widget.sharedprefsList.add(user1);
            }
          }
        }
        getMessageTime(widget.sharedprefsList);

        print('test1');
        print(newList);
        /*if ('23456A1T1'.substring(0, 9).codeUnitAt(0) <
            '23456A1T2'.substring(0, 9).codeUnitAt(0)) {
          print('first is small');
        } else {
          print('second is small');
        }*/
        /*for (int i = 0; i < a.length; i++) {
          if (a.substring(i, i + 1) == b.substring(i, i + 1)) {
            continue;
          } else {*/

        //sharedprefsList = sharedprefsList;
        saveChat(widget.sharedprefsList);
        widget.listCallBack(widget.sharedprefsList);

        for (int i = 0; i < widget.sharedprefsList.length; i++) {
          final chatTile = ChatTile(
            receiver: widget.sharedprefsList[i],
            loggedInUser: widget.loggedInUser,
            notification: false,
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
  }
}
