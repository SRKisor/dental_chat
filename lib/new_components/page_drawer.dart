import 'package:dental_chat/Screens/chat_list_screen.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:dental_chat/new_components/add_admin.dart';
import 'package:dental_chat/new_components/alert.dart';
import 'package:dental_chat/new_components/all_message.dart';
import 'package:dental_chat/new_components/profile_page.dart';
import 'package:dental_chat/new_screens/all_chats.dart';
import 'package:dental_chat/new_screens/chat_screen.dart';
import 'package:dental_chat/new_screens/contact_us_screen.dart';
import 'package:dental_chat/new_screens/home_screen.dart';
import 'package:dental_chat/new_screens/our_services_screen.dart';
import 'package:dental_chat/new_screens/user_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PageDrawer extends StatefulWidget {
  @override
  _PageDrawerState createState() => _PageDrawerState();
}

class _PageDrawerState extends State<PageDrawer> {
  String email;
  String userName;
  User loggedInUser = FirebaseAuth.instance.currentUser;
  String userType;

  @override
  void initState() {
    print(loggedInUser.photoURL);
    print(loggedInUser.displayName);

    super.initState();
    getUser();
  }

  getUser() async {
    userType = await LocalUserData.getUserTypeKey();
    email = await LocalUserData.getUserEmailKey();
    userName = await LocalUserData.getUserNameKey();
    print(userType);
    setState(() {});
    //email = loggedInUser.email;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[200],
                Colors.blue[700],
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  height: 200,
                ),
                /*GestureDetector(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                  ),
                ),*/
                ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.home,
                    size: 40,
                    color: Colors.white70,
                  ),
                  title: Text(
                    'HOME',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  enabled: true,
                  onTap: () async {
                    if (loggedInUser == null) {
                      showDialog(
                        context: context,
                        builder: (_) => Alert(),
                      );
                    } else {
                      userType = await LocalUserData.getUserTypeKey();
                      userType == 'User'
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(
                                  receiver: 'Our Agent',
                                  loggedInUser: email,
                                  chatId: 'Our Agent_$email',
                                  userType: 'User',
                                ),
                              ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AllChatScreen(),
                              ),
                            );
                    }
                  },
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.chat_bubble,
                      size: 30,
                      color: Colors.white70,
                    ),
                  ),
                  title: Text(
                    ' APMDH BOT',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  enabled: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OurServicesScreen(
                          email: email,
                          userName: userName,
                        ),
                      ),
                    );
                  },
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: Icon(
                      Icons.home_repair_service_sharp,
                      size: 30,
                      color: Colors.white70,
                    ),
                  ),
                  title: Text(
                    ' Dental Advertise',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  enabled: true,
                  onTap: () async {
                    userType = await LocalUserData.getUserTypeKey();
                    userType == 'Admin'
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllMessage()))
                        : Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactUsScreen(),
                            ),
                          );
                  },
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      Icons.contact_page,
                      size: 30,
                      color: Colors.white70,
                    ),
                  ),
                  title: Text(
                    ' Contact Us',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          Material(
            elevation: 5,
            color: Colors.blue[800],
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
            child: Container(
              height: 200,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));*/
                      },
                      child: CircleAvatar(
                        child: loggedInUser == null ||
                                loggedInUser.photoURL == null
                            ? Icon(
                                Icons.person,
                                size: 40,
                              )
                            : Image.network(loggedInUser.photoURL),
                        radius: 30,
                      ),
                    ),
                  ),
                  Text(
                    loggedInUser == null ? 'No User' : loggedInUser.displayName,
                    style: TextStyle(fontSize: 25),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
