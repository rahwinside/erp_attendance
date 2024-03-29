import 'dart:io' show Platform;

import 'package:flutter/material.dart';

class AboutFragment extends StatelessWidget {
  String detect_client() {
    if (Platform.isAndroid) {
      return "Android";
    } else if (Platform.isIOS) {
      return "iPhone";
    } else if (Platform.isMacOS) {
      return "Darwin x64";
    } else {
      return "Blazor Web";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Image.asset(
                  "images/xstack.png",
                  fit: BoxFit.fill,
                  width: 75.0,
                  height: 75.0,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 10),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Communicator",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "for xStack",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            RichText(
              text: TextSpan(
                text:
                    'xStack is an Enterprise Resource Planning software designed, built and maintained by ',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Pon Rahul',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'Daniel Mark',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text:
                        '. It was made possible by the open-source Mer project and the closed-source MixSpace project.',
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        "xStack Client: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                      Text(
                        "mer subsystem for " + detect_client(),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  child: Text(
                    "version 1.1.2 alpha",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
//            Wrap(
//              children: <Widget>[
//                Text(
//                  "© 2020 ",
//                  style: TextStyle(
//                    color: Colors.black,
//                    fontFamily: 'Poppins',
//                    fontWeight: FontWeight.w600,
//                  ),
//                ),
//                Text(
//                  "MixSpace Internet Services",
//                  style: TextStyle(
//                    color: Colors.deepPurple,
//                    fontFamily: 'Poppins',
//                    fontWeight: FontWeight.w600,
//                  ),
//                ),
//              ],
//            ),
                Wrap(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          "© 2020 ",
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "Mer Community",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Under GNU General Public License 2.0",
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Flexible(
                  child: Text(
                    "Terms of use",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Flexible(
                  child: Text(
                    "Privacy statement",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                Flexible(
                  child: Text(
                    "xStack services agreement",
                    style: TextStyle(
                      color: Colors.deepPurple,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
