import 'package:dental_chat/constants.dart';
import 'package:dental_chat/new_components/logo_background.dart';
import 'package:dental_chat/new_components/page_drawer.dart';
import 'package:dental_chat/new_screens/login_screen.dart';
import 'package:dental_chat/new_screens/user_selection_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({this.email, this.userName});
  final email;
  final userName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      drawer: PageDrawer(),
      body: Builder(
        builder: (context) => Container(
          child: SafeArea(
            child: Container(
              color: Colors.blue,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [
                                  Colors.blue[400],
                                  Colors.blue[900],
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                          ),
                          //color: Colors.blue,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 150,),
                                //Spacer(),
                                Center(
                                  //padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      LogoBg(
                                        length: 150,
                                      ),
                                      Center(
                                        child: Container(
                                          height: 120,
                                          width: 120,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              LogoBg(
                                                length: 120,
                                              ),
                                              Hero(
                                                tag: 'logo',
                                                child: Container(
                                                  height: 120,
                                                  width: 120,
                                                  child: Image.asset(
                                                      'images/logo.png'),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              Container(
                                padding: EdgeInsets.only(top: 70,left: 30),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  kAppContentTitle,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                                width: MediaQuery.of(context).size.width,
                                child: Text(
                                  kAppContentBody,
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      /*Expanded(
                        flex: 8,
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(40),
                              topLeft: Radius.circular(40),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              'Dental Chat',
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: GestureDetector(
                          onTap: () {
                            Scaffold.of(context).openDrawer();
                          },
                          onLongPress: () {},
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.grey[300],
                            child: Icon(
                              Icons.list,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Text(
                            'Login',
                            style: TextStyle(
                                color: Colors.blue[100],
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
