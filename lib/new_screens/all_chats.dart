import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/new_screens/chat_screen.dart';
import 'package:flutter/material.dart';

class AllChatScreen extends StatefulWidget {
  const AllChatScreen({Key key}) : super(key: key);

  @override
  _AllChatScreenState createState() => _AllChatScreenState();
}

class _AllChatScreenState extends State<AllChatScreen> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List allChatList = [];
  getChats() async {
    getDate();
    List newList = [];
    await _firestore
        .collection('chatRoom')
        .orderBy('time', descending: true)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        newList.add({
          'email': element['user_2'],
          'message': element['message'],
          'chatId': element['chatId'],
        });
      });
    }).catchError((e) {
      print(e);
    });
    allChatList = newList;
    return allChatList;
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getChats(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('All Chats'),
              ),
              body: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 1,
                      height: 0,
                    );
                  },
                  itemCount: allChatList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.grey[300],
                      leading: CircleAvatar(
                        child: Text(allChatList[index]['email']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase()),
                      ),
                      title: Container(
                        child: Text(
                          allChatList[index]['email'],
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      subtitle: Container(
                        child: Text(
                            allChatList[index]['message'].toString().length > 20
                                ? allChatList[index]['message']
                                        .toString()
                                        .substring(0, 20) +
                                    '...'
                                : allChatList[index]['message'].toString()),
                      ),
                      onTap: () {
                        print(allChatList[index]['email']);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                      chatId: allChatList[index]['chatId'],
                                      userType: 'Admin',
                                      loggedInUser: 'Our Agent',
                                      receiver: allChatList[index]['email'],
                                    )));
                      },
                    );
                  }),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Text('All Chats'),
              ),
              body: ListView.separated(
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 1,
                      height: 0,
                    );
                  },
                  itemCount: allChatList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      tileColor: Colors.grey[300],
                      leading: CircleAvatar(
                        child: Text(allChatList[index]['email']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase()),
                      ),
                      title: Container(
                        child: Text(
                          allChatList[index]['email'],
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      subtitle: Container(
                        child: Text(
                            allChatList[index]['message'].toString().length > 20
                                ? allChatList[index]['message']
                                        .toString()
                                        .substring(0, 20) +
                                    '...'
                                : allChatList[index]['message'].toString()),
                      ),
                    );
                  }),
            );
          }
        });
  }
}
