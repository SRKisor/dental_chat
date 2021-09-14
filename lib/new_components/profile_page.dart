import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/new_screens/contact_us_screen.dart';
import 'package:dental_chat/new_services/firebase_file.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User loggedInUser = FirebaseAuth.instance.currentUser;

  getUserInfo() async {
    Map userInfo = {};
    await _firestore
        .collection('User')
        .doc(loggedInUser.uid)
        .get()
        .then((value) {
      userInfo = value.data();
    });
    return userInfo;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map userInfo = snapshot.data;
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue[300],
                    Colors.blue[900],
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Material(
                  elevation: 3,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.only(top: 40, bottom: 40),
                            child: Text(
                              'Hi ' + userInfo['userName'] + ' !',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white),
                            ),
                          ),
                          Container(
                            child: Text(
                              'Your Appointments',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            height: 150,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: userInfo['appointments'].length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Material(
                                        color: Colors.blue.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                        elevation: 3,
                                        shadowColor: Colors.black,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            border: new Border.all(
                                                width: 1,
                                                color: Colors.black26),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          width: 150,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Container(
                                                child: Text(
                                                  userInfo['appointments']
                                                      [index]['dentistName'],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                  child: Text(
                                                userInfo['appointments'][index]
                                                    ['date'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                              Container(
                                                  child: Text(
                                                userInfo['appointments'][index]
                                                    ['time'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                ),
                                              )),
                                            ],
                                          ),
                                        )),
                                  );
                                }),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            child: Text(
                              'email',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            child: Text(
                              loggedInUser.email,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Colors.blue[300],
                    Colors.blue[900],
                  ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                child: Material(
                  elevation: 3,
                  color: Colors.transparent,
                  child: Container(),
                ),
              ),
            );
          }
        });
  }
}
