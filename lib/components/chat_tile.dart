import 'package:dental_chat/services/chat_room_id_generator.dart';
import 'package:flutter/material.dart';
import 'package:dental_chat/Screens/chat_screen.dart';

class ChatTile extends StatelessWidget {
  ChatTile(
      {@required this.receiver,
      @required this.loggedInUser,
      this.notification});
  final String receiver;
  final loggedInUser;
  final notification;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print('hi');
        final chatId =
            ChatRoomGenerator.getChatRoomId(a: receiver, b: loggedInUser);
        print(loggedInUser);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: receiver,
              loggedInUser: loggedInUser,
              chatId: chatId,
            ),
          ),
        );
      },
      child: Column(
        children: [
          Divider(
            height: 0,
            color: Colors.black,
            thickness: 1,
            indent: 20,
          ),
          Container(
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: CircleAvatar(
                    child: Text(
                      'A',
                      style: TextStyle(fontSize: 30),
                    ),
                    radius: 30,
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(receiver),
                                Text(''),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                child: Text(''),
                                width: 200,
                              ),
                              notification
                                  ? CircleAvatar(
                                      radius: 8,
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            color: Colors.grey,
            height: 70,
          ),
        ],
      ),
    );
  }
}
