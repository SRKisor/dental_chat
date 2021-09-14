import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/constants.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:dental_chat/new_components/network_error_alert.dart';
import 'package:dental_chat/new_screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileAddingScreen extends StatefulWidget {
  ProfileAddingScreen({this.userName, this.email});
  final userName;
  final email;

  @override
  _ProfileAddingScreenState createState() => _ProfileAddingScreenState();
}

class _ProfileAddingScreenState extends State<ProfileAddingScreen> {
  File selectedImage;
  bool canShowUploadButton = false;
  String uploadButtonText = 'Upload';
  bool photoSelected = false;

  bool notConnected = false;

  User loggedInUser = FirebaseAuth.instance.currentUser;
  int userAge;
  bool isConnected = false;
  final formKey = GlobalKey<FormState>();
  String photoURL;

  validate() {
    if (formKey.currentState.validate()) {}
  }

  uploadImage(int userAge) async {
    if (selectedImage != null) {
      final Reference _storageRef = FirebaseStorage.instance.ref().child(
          'User files/${loggedInUser.uid}/Profile Picture/${loggedInUser.uid}');

      await _storageRef.putFile(selectedImage).whenComplete(() async {
        await _storageRef.getDownloadURL().then((value) {
          loggedInUser.updatePhotoURL(value);
          photoURL = value;
        });
      });
    }

    loggedInUser.updateDisplayName(widget.userName);
    FirebaseFirestore.instance.collection('User').doc(loggedInUser.uid).set({
      'userName': widget.userName,
      'email': widget.email,
      'uid': loggedInUser.uid,
      'photoURL': photoURL,
      'age': userAge,
      'userType' : 'User',
    });
    LocalUserData.saveLoggedInKey(true);
    LocalUserData.saveUserNameKey(widget.userName);
    LocalUserData.saveUserEmailKey(widget.email);
    LocalUserData.savePhotoURL(photoURL);
    LocalUserData.saveAge(userAge);
    LocalUserData.saveLoggedInUserType('User');
    isConnected = true;
  }

/*
  DropdownButton dropDown(List dropList, String type) {
    List<DropdownMenuItem> dropdownList = [];
    for (String listItem in dropList) {
      var newItem = DropdownMenuItem(
        child: Text(
          listItem,
          style: TextStyle(color: Colors.white),
        ),
        value: listItem,
      );
      dropdownList.add(newItem);
    }
    return DropdownButton(
      dropdownColor: Colors.blueGrey,
      value: type == 'medium' ? selectedMedium : selectedStream,
      items: dropdownList,
      onChanged: (value) {
        type == 'medium' ? selectedMedium = value : selectedStream = value;
        setState(() {});
        selectedMedium != '' || selectedStream != ''
            ? canShowUploadButton = true
            : photoSelected
            ? canShowUploadButton = true
            : canShowUploadButton = false;
      },
    );
  }
*/

  @override
  void dispose() {
    uploadImage(userAge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue[400],
                Colors.blue[900],
              ], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
          ),
          Container(
            child: Center(
              child: ListView(children: [
                Center(
                  child: GestureDetector(
                    onTap: () async {
                      var result = await ImagePicker()
                          .getImage(
                        source: ImageSource.gallery,
                        imageQuality: 25,
                      )
                          .then((value) {
                        setState(() {
                          selectedImage = File(value.path);
                          canShowUploadButton = true;
                        });
                      });
                    },
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(10)),
                      child: selectedImage == null
                          ? Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add),
                                    Text('Add Your Profile Picture')
                                  ]),
                            )
                          : Image.file(
                              selectedImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 20),
                  child: Row(children: [
                    Container(
                      padding: EdgeInsets.only(left: 50, right: 10),
                      child: Text(
                        'Your Age :',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      width: 150,
                      child: Form(
                        key: formKey,
                        child: TextFormField(
                          validator: (val) {
                            bool validated = true;
                            try {
                              int value = int.parse(val);
                              if (value > 150) {
                                validated = false;
                              }
                            } on Exception catch (e) {
                              validated = false;
                            }
                            print('');
                            if (val == '') {
                              validated = true;
                            }
                            print(validated);
                            return validated
                                ? null
                                : 'Please Input a valid age';
                          },
                          textAlign: TextAlign.center,
                          obscureText: true,
                          onChanged: (value) {
                            validate();
                            userAge = int.parse(value);
                          },
                          decoration:
                              InputDecoration(hintText: 'Enter your age'),
                        ),
                      ),
                    ),
                  ]),
                ),
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            uploadButtonText = 'Uploading';
                          });
                          await uploadImage(userAge);
                          if (isConnected) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                          } else {
                            notConnected = true;
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blue[900],
                          ),
                          child: Center(
                              child: Text(
                            canShowUploadButton ? uploadButtonText : 'Skip',
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      ),
                    ),
                  ),
                )
              ]),
            ),
          ),
          NotConnectedAlert(notConnected: notConnected),
        ],
      ),
    );
  }
}
