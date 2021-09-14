import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';
import 'package:dental_chat/components/message_bubble.dart';

final _fireStore = FirebaseFirestore.instance;
//User loggedInUser;

class MessagesStream extends StatelessWidget {
  MessagesStream(
      {@required this.receiver,
      @required this.loggedInUser,
      @required this.chatId});
  final receiver;
  final loggedInUser;
  final chatId;

  @override
  Widget build(BuildContext context) {
  
    return StreamBuilder<QuerySnapshot>(

      stream: _fireStore
          .collection('chatRoom')
          .doc(chatId)
          .collection('chat')
          .orderBy('date')
          .snapshots(),
      builder: (BuildContext context, snapshot) {
        List<MessageBubble> messageBubbles = [];
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        } else {
          final messages = snapshot.data.docs.reversed;

          for (var message in messages) {
            final messageText = message['text'];
            final messageSender = message['sender'];
      

            // chat Message Bubble

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: loggedInUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              children: messageBubbles,
            ),
          );
        }
      },
    );
  }
}
