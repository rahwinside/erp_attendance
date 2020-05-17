import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment/modify_attendance_presenter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'StudentListFragment.dart';

var username = "";
var auth_token = "";
var hour = "1";

final scaffoldKey = new GlobalKey<ScaffoldState>();

final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
List<bool> hourSelected = [
  true,
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
TextEditingController messageController = new TextEditingController();

String pk_table;

// takeAttendance button is deactivated by default
bool buttonActive = false;

class ModifyAttendanceFragment extends StatefulWidget {
  ModifyAttendanceFragment({Key key}) : super(key: key);

  @override
  _ModifyAttendanceFragmentState createState() {
    return new _ModifyAttendanceFragmentState();
  }
}

class _ModifyAttendanceFragmentState extends State<ModifyAttendanceFragment>
    implements ModifyAttendanceFragmentContract {
  void preselect(dynamic res) {
    dateController.text = res["datetime"].toString();
    switch (res["department"].toString().toLowerCase()) {
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
    yearController.text = res["year"].toString();
    semesterController.text = res["semester"].toString();
    subjectController.text = res["subject_code"].toString().toUpperCase() +
        " - " +
        res["subject_name"].toString();
    messageController.text = "";
    setState(() {});
  }

  ModifyAttendanceFragmentPresenter _presenter;

  _ModifyAttendanceFragmentState() {
//    resetUsers();
    dateController.text = "";
    deptController.text = "";
    yearController.text = "";
    semesterController.text = "";
    subjectController.text = "";
    messageController.text = "";
    hourSelected = [true, false, false, false, false, false, false, false];
    buttonActive = false;
    _presenter = new ModifyAttendanceFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      _presenter.doFetch(username, auth_token, hour);
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      body: Column(
        children: <Widget>[
          new Expanded(
            flex: 9,
            child: SingleChildScrollView(
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
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
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
                          hourSelected = [
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false,
                            false
                          ];
                          hourSelected[index] = true;
                          _presenter.doFetch(username, auth_token, (index + 1)
                              .toString());
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
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
                    new Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    new Wrap(
                      children: <Widget>[
                        new Padding(padding: EdgeInsets.only(top: 5.0)),
                        new Text(
                          messageController.text,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ),
          new Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: new BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new RaisedButton(
                      key: null,
                      onPressed: !buttonActive ? null : buttonPressed,
//                  onPressed: buttonPressed,
                      color: Colors.white,
                      splashColor: Colors.purple,
                      elevation: 5.0,
                      child: new Text(
                        "Modify Attendance",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void buttonPressed() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => StudentListFragment(pk_table: pk_table)));
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onFetchError(String errorTxt) {
    _showSnackBar(errorTxt.substring(11));
    messageController.text = errorTxt.substring(11) + ".";
    dateController.text = "";
    deptController.text = "";
    yearController.text = "";
    semesterController.text = "";
    subjectController.text = "";
    print(errorTxt);
    setState(() {
      buttonActive = false;
    });
    // TODO: implement onFetchError
  }

  @override
  void onFetchSuccess(res) {
    if (res != "invalid-auth-or-access") {
      preselect(res);
    }
    setState(() {
      buttonActive = true;
    });
  }
}
