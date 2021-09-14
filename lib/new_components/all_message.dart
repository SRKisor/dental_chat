import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AllMessage extends StatefulWidget {
  const AllMessage({Key key}) : super(key: key);

  @override
  _AllMessageState createState() => _AllMessageState();
}

class _AllMessageState extends State<AllMessage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List messages = [];

  getMessages() async {
    List messagesList = [];
    await _firestore
        .collection('Contact Us')
        .orderBy('time')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        messagesList.add({
          'time': element['time'],
          'message': element['message'],
        });
      });
    });
    print('messagesList1$messagesList');
    messagesList = messagesList.reversed.toList();
    print('messagesList2$messagesList');
    messages = messagesList;
    print('messages$messages');
    return messages;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getMessages(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text('User Responses'),
            ),
            body: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Material(
                    elevation: 5,
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        //Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              tag: 'Name',
                              messages: messages,
                              index: index,
                              section: 'name'),
                          TextWidget(
                              tag: 'Email',
                              index: index,
                              section: 'email',
                              messages: messages),
                          TextWidget(
                              tag: 'Phone Number',
                              index: index,
                              section: 'phoneNumber',
                              messages: messages),
                          TextWidget(
                              tag: 'Message',
                              index: index,
                              section: 'message',
                              messages: messages),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else
          return Scaffold(
            backgroundColor: Colors.white,
          );
      },
    );
  }
}

class TextWidget extends StatelessWidget {
  const TextWidget({
    Key key,
    @required this.index,
    @required this.section,
    @required this.messages,
    @required this.tag,
  }) : super(key: key);
  final tag;
  final section;
  final index;
  final List messages;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(children: [
          Text(
            '$tag : ',
            style: TextStyle(color: Colors.grey[700], fontSize: 17),
          ),
          Container(
            child: Text(
              messages[index]['message'][section],
              style: TextStyle(color: Colors.black87, fontSize: 17),
            ),
          )
        ]));
  }
}
