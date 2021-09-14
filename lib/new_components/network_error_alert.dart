import 'package:flutter/material.dart';

class NotConnectedAlert extends StatelessWidget {
  const NotConnectedAlert({
    Key key,
    @required this.notConnected,
  }) : super(key: key);

  final bool notConnected;

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: notConnected,
        child: Center(
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 5,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.7,
              child: Column(
                children: [
                  Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.signal_wifi_connected_no_internet_4),
                        Container(
                          padding:
                              EdgeInsets.only(left: 10, top: 30, bottom: 25),
                          child: Text(
                            'Not Connected',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ]),
                  Divider(
                    thickness: 0.75,
                    indent: 15,
                    endIndent: 15,
                    color: Colors.black,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: 25,
                      right: 25,
                    ),
                    child: Text(
                      'You Are Not Connected to internet. Please connect to internet and try again',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                      child: Text('Ok'),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
