import 'package:flutter/material.dart';

class AboutFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              "AppName",
              style: TextStyle(
                fontFamily: "Poppins",
              ),
            ),
            Text("Communicator"),
          ],
        ),
      )),
    );
  }
}
