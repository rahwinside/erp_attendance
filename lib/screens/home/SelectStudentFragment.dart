import 'package:flutter/material.dart';

class AttendanceFragment extends StatefulWidget {
  AttendanceFragment({Key key}) : super(key: key);

  @override
  _AttendanceFragmentState createState() => new _AttendanceFragmentState();
}

class _AttendanceFragmentState extends State<AttendanceFragment> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[new RaisedButton(onPressed: null)]),
      ),
    );
  }

  void buttonPressed() {}

  void popupButtonSelected(String value) {}
}
