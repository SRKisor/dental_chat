import 'package:flutter/material.dart';

class AddAdmin extends StatefulWidget {
  const AddAdmin({Key key}) : super(key: key);

  @override
  _AddAdminState createState() => _AddAdminState();
}

class _AddAdminState extends State<AddAdmin> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Admin'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.blue[200],
            Colors.blue[700],
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: ListView(
          children: [
            SizedBox(
              height: 70,
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            TextField(),
          ],
        ),
      ),
    );
  }
}
