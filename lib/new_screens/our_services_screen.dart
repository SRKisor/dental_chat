import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_chat/constants.dart';
import 'package:dental_chat/helper_function.dart';
import 'package:dental_chat/new_components/drawer_button.dart';
import 'package:dental_chat/new_components/page_drawer.dart';
import 'package:dental_chat/new_screens/advertisement_screen.dart';
import 'package:dental_chat/new_services/firebase_file.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class OurServicesScreen extends StatefulWidget {
  OurServicesScreen({@required this.email, @required this.userName});
  final email;
  final userName;

  @override
  _OurServicesScreenState createState() => _OurServicesScreenState();
}

class _OurServicesScreenState extends State<OurServicesScreen> {
  File selectedImage;
  bool canShowUploadButton = false;
  String uploadButtonText = 'Upload';
  List advertisementList = [];
  List imageRef = [];
  bool delete = false;
  bool loading = true;

  @override
  void initState() {
    //listExample();
    getAds();
    super.initState();
  }

/*
  Future<List<FirebaseFile>> listExample() async {
    ListResult result =
        await FirebaseStorage.instance.ref('advertisements/').listAll();
    final urls = await Future.wait(
        result.items.map((ref) => ref.getDownloadURL()).toList());

    List adList = urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);
          return MapEntry(index, file);
        })
        .values
        .toList();

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }
*/

  PickedFile imagePicked;

  List<File> imageList = [];

  Future addImgAdvertisement(bool isLeft) async {
    print('test1');
    imagePicked = await ImagePicker()
        .getImage(source: ImageSource.gallery)
        .catchError((e) {
      print(e);
    });
    if (imagePicked != null) {
      print('test2');
      setState(() {
        selectedImage = File(imagePicked.path);
        canShowUploadButton = true;
      });
    }
  }

  deleteAd(imageInfo) async {
    await FirebaseFirestore.instance
        .collection('advertisements')
        .doc(imageInfo[1])
        .delete();
    adList.remove(imageInfo);
    setState(() {
      delete = false;
    });
  }

  uploadImage() async {
    setState(() {
      uploadButtonText = 'Uploading ...';
    });
    /*await FirebaseFirestore.instance
        .collection('advertisements')
        .doc('lastImageName')
        //.where('title', isEqualTo: 'lastImage')
        .get()
        .then((value) => lastImageName = value['lastImageName']);*/

    String imageName = DateTime.now().toString();
    print(imageName);
    final Reference _storageRef =
        FirebaseStorage.instance.ref().child('advertisements/$imageName');

    await _storageRef.putFile(selectedImage).whenComplete(() async {
      print('upload to storage completed');
      await _storageRef.getDownloadURL().then((value) async {
        adList.insert(0, [value, imageName]);
        await FirebaseFirestore.instance
            .collection('advertisements')
            .doc(imageName)
            .set({'imageName': imageName, 'Link': value})
            .whenComplete(() => print('database updated'))
            .catchError((e) {
              print(e);
            });
      }).catchError((e) {
        print(e);
      });
    });

    setState(() {
      imageRef = [];
      uploadButtonText = 'upload';
      selectedImage = null;
      canShowUploadButton = false;
    });
  }

  //List getImageList() async {}
  buildAdTileList() {
    List<Widget> leftAdList = [];
    List<Widget> rightAdList = [];
    adWidgetList = [];

    print(userType);
    print(selectedImage);
    if (userType == 'Admin') {
      adWidgetList.add(
        GestureDetector(
          onTap: () {
            addImgAdvertisement(true);
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Card(
              color: Colors.white70,
              child: selectedImage == null
                  ? Icon(Icons.add)
                  : Image.file(selectedImage),
            ),
          ),
        ),
      );
    }
    print(adWidgetList);
    for (int i = 0; i < adList.length; i++) {
      adWidgetList.add(
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AdvertisementScreen(image: adList[i][0]),
                  ),
                );
              },
              onLongPress: () {
                setState(() {
                  delete = true;
                });
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                elevation: 5,
                child: Image.network(adList[i][0]),
              ),
            ),
            delete
                ? GestureDetector(
                    onTap: () {
                      deleteAd(adList[i]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        backgroundColor: Colors.white,
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
    }

    for (int i = 0; i < adWidgetList.length; i++) {
      i % 2 == 0
          ? leftAdList.add(adWidgetList[i])
          : rightAdList.add(adWidgetList[i]);
    }

    return ListView(
      shrinkWrap: true,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: leftAdList,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: rightAdList,
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15),
          child: Center(
            child: GestureDetector(
              onTap: () {
                uploadImage();
              },
              child: canShowUploadButton
                  ? Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue,
                      child: Container(
                        width: 125,
                        height: 35,
                        padding: EdgeInsets.all(5),
                        child: Center(
                          child: Text(
                            uploadButtonText,
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : Container(),
            ),
          ),
        ),
      ],
    );

/*
    return FutureBuilder<QuerySnapshot>(
      future: advertisements.where('title', isEqualTo: 'advertisement').get(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container(child: Center(child: CircularProgressIndicator()));
        }
        if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Text(snapshot.error.toString.toString());
        }
      },
    );
*/
  }

  List adList = [];
  List adWidgetList = [];
  String userType;
  getAds() async {
    adList = [];
    await FirebaseFirestore.instance
        .collection('advertisements')
        .orderBy('imageName')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        adList.insert(0, [element['Link'], element['imageName']]);
      });
    });
    //adList.reversed;
    /*.catchError((e) {
      print(e);
      adList = [];
    })*/
    ;

    setState(() {
      loading = false;
    });

    userType = await LocalUserData.getUserTypeKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: PageDrawer(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: false,
                snap: false,
                floating: false,
                leading: null,
                automaticallyImplyLeading: false,
                expandedHeight: 150.0,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(kAppTitle),
                  background: Image.asset('images/logo.png'),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return loading
                        ? Container(
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : buildAdTileList();
                  },
                  childCount: 1,
                ),
              ),
            ],
          ),
          SafeArea(child: DrawerButton()),
        ],
      ),
    );
  }
}
