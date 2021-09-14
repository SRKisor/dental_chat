import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final User loggedInUser = FirebaseAuth.instance.currentUser;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _messageController = TextEditingController();
  bool isActive = false;

  upload() async {
    await _firestore.collection('Contact Us').add({
      'time': DateTime.now().toString(),
      'message': {
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'phoneNumber': _phoneNumberController.text.trim(),
        'message': _messageController.text.trim(),
      }
    }).catchError((e) async {
      await _firestore.collection('Contact Us').add({
        DateTime.now().toString(): {
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'phoneNumber': _phoneNumberController.text.trim(),
          'message': _messageController.text.trim(),
        }
      });
    });
    _messageController.clear();
    _nameController.clear();
    _emailController.clear();
    _phoneNumberController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue[400],
            Colors.blue[900],
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        padding: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.center,
        child: Center(
          child: ListView(
            children: [
              Center(
                child: Container(
                  padding: EdgeInsets.only(
                    top: 70,
                  ),
                  child: Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 30,
                ),
                child: Text(
                  'Name : ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                onChanged: (val) {
                  isActive = _nameController.text.trim().length != 0 &&
                      _emailController.text.trim().length != 0 &&
                      _messageController.text.trim().length != 0;
                  setState(() {});
                },
                controller: _nameController,
                decoration: InputDecoration(
                  focusColor: Colors.white,
                ),
                textCapitalization: TextCapitalization.words,
                style: TextStyle(color: Colors.white70),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Email : ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                onChanged: (val) {
                  isActive = _nameController.text.trim().length != 0 &&
                      _emailController.text.trim().length != 0 &&
                      _messageController.text.trim().length != 0;
                  setState(() {});
                },
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Colors.white70),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Mobile Number : ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Colors.white70),
              ),
              Container(
                padding: EdgeInsets.only(
                  top: 20,
                ),
                child: Text(
                  'Message : ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Container(
                  height: 100,
                  child: TextField(
                    onChanged: (val) {
                      isActive = _nameController.text.trim().length != 0 &&
                          _emailController.text.trim().length != 0 &&
                          _messageController.text.trim().length != 0;
                      setState(() {});
                    },
                    controller: _messageController,
                    keyboardType: TextInputType.multiline,
                    style: TextStyle(color: Colors.white70),
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 10,
                  )),
              Container(
                padding: EdgeInsets.only(top: 50),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      print(isActive);
                      isActive ? upload() : null;
                    },
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: isActive ? Colors.blue[900] : Colors.blue[200],
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: isActive
                              ? Colors.blue[900]
                              : Colors.blueGrey[400],
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            color: isActive ? Colors.white : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
