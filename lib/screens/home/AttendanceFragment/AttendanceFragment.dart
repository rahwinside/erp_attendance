import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment/attendance_presenter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var username = "";
var auth_token = "";

final scaffoldKey = new GlobalKey<ScaffoldState>();
final List<String> department = <String>[
  "Information Technology",
  "Computer Science and Engineering",
  "Electrical and Electronics Engineering",
  "Electronics and Communication Engineering",
  "Mechanical Engineering",
];

final List<String> year = <String>[
  "I",
  "II",
  "III",
  "IV",
];

final List<String> year1 = <String>[
  "01",
  "02",
];
final List<String> year2 = <String>[
  "03",
  "04",
];
final List<String> year3 = <String>[
  "05",
  "06",
];
final List<String> year4 = <String>[
  "07",
  "08",
];

final List<String> subject = <String>[
  "Waiting for API Endpoint",
  "Waiting for API",
];

var _valueSem = "01";
var _valueDept = "Information Technology";
var _valueYear = "I";
var _valueSubject = "Waiting for API Endpoint";
var _season = "even";

final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
final List<bool> hourSelected = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

TextEditingController dateController = new TextEditingController();
TextEditingController deptController = new TextEditingController();
TextEditingController yearController = new TextEditingController();
TextEditingController semesterController = new TextEditingController();
TextEditingController subjectController = new TextEditingController();

class AttendanceFragment extends StatefulWidget {
  AttendanceFragment({Key key}) : super(key: key);

  @override
  _AttendanceFragmentState createState() {
//    preselect();
    return new _AttendanceFragmentState();
  }
}

class _AttendanceFragmentState extends State<AttendanceFragment>
    implements AttendanceFragmentContract {
  void preselect(dynamic res) {
    dateController.text = res["datetime"].toString();
    switch (res["department"]) {
      case "dit":
        deptController.text = "Information Technology";
        break;
      case "dcse":
        deptController.text = "Computer Science and Engineering";
        break;
      case "dmea":
        deptController.text = "Mechanical Engineering A";
        break;
      case "dmeb":
        deptController.text = "Mechanical Engineering B";
        break;
      case "deee":
        deptController.text = "Electrical and Electronics Engineering";
        break;
      case "dece":
        deptController.text = "Electronics and Communication Engineering";
        break;
    }
//    yearController.text =
    semesterController.text = res["semester"].toString();
    switch (res["semester"]) {
      case "1":
        yearController.text = "I";
        break;
      case "2":
        yearController.text = "I";
        break;
      case "3":
        yearController.text = "II";
        break;
      case "4":
        yearController.text = "II";
        break;
      case "5":
        yearController.text = "III";
        break;
      case "6":
        yearController.text = "III";
        break;
      case "7":
        yearController.text = "IV";
        break;
      case "8":
        yearController.text = "IV";
        break;
    }
    subjectController.text = res["subject_code"].toString().toUpperCase() +
        " - " +
        res["subject_name"].toString();
    hourSelected[int.parse(res["hour"]) - 1] = true;
    setState(() {});
  }

  AttendanceFragmentPresenter _presenter;

  _AttendanceFragmentState() {
//    resetUsers();
    _presenter = new AttendanceFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      _presenter.doFetch(username, auth_token);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: new SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: new TextField(
                    enabled: false,
                    controller: dateController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      labelText: "Date of class",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
//                decoration: new BoxDecoration(
//                  border: new Border.all(color: Colors.black38),
//                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
//                ),
                  child: new TextField(
                    enabled: false,
                    controller: deptController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      labelText: "Department",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    ),
                  )),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Padding(padding: EdgeInsets.only(left: 5)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          new TextField(
                            enabled: false,
                            controller: yearController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              labelText: "Year",
                              labelStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w200,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(right: 5)),
                    new Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextField(
                            enabled: false,
                            controller: semesterController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(0),
                              labelText: "Semester",
                              labelStyle: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w200,
                                color: Colors.black,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ]),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Container(
                  padding: EdgeInsets.only(left: 5, right: 5),
                  child: TextField(
                    enabled: false,
                    controller: subjectController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(0),
                      labelText: "Subject",
                      labelStyle: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w200,
                        color: Colors.black,
                      ),
                    ),
                  )),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: new Text(
                  "Hour",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Poppins"),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: ToggleButtons(
                  children: <Widget>[
                    Text("1"),
                    Text("2"),
                    Text("3"),
                    Text("4"),
                    Text("5"),
                    Text("6"),
                    Text("7"),
                    Text("8"),
                  ],
                  isSelected: hourSelected,
                  onPressed: (int index) {
                    setState(() {});
                  },
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              new RaisedButton(
                  key: null,
                  onPressed: buttonPressed,
                  color: Colors.deepPurple,
                  splashColor: Colors.purple,
                  elevation: 5.0,
                  child: new Text(
                    "Take Attendance",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                    ),
                  ))
            ]),
      ),
    );
  }

  void buttonPressed() {}

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onFetchError(String errorTxt) {
    _showSnackBar("Error: " + errorTxt);
    // TODO: implement onFetchError
  }

  @override
  void onFetchSuccess(res) {
    if (res != "invalid-auth-or-access") {
      preselect(res);
    } else {
      _showSnackBar("Invalid auth token or access level!");
    }
  }
}
