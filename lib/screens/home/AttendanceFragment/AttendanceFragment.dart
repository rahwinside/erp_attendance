import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment/attendance_presenter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'StudentListFragment.dart';

var username = "";
var auth_token = "";

final scaffoldKey = new GlobalKey<ScaffoldState>();

final dateFormat = DateFormat("EEEE, MMMM d, yyyy");
List<bool> hourSelected = [
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
TextEditingController messageController = new TextEditingController();

String pk_table, datetime_column;

// takeAttendance button is deactivated by default
bool buttonActive = false;

class AttendanceFragment extends StatefulWidget {
  AttendanceFragment({Key key}) : super(key: key);

  @override
  _AttendanceFragmentState createState() {
    return new _AttendanceFragmentState();
  }
}

class _AttendanceFragmentState extends State<AttendanceFragment>
    implements AttendanceFragmentContract {
  void preselect(dynamic res) {
    datetime_column = res["datetime_column"].toString();
    print(datetime_column);
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
    messageController.text = "";
    pk_table = res["subCode_dept_sem"];
    setState(() {});
  }

  AttendanceFragmentPresenter _presenter;

  _AttendanceFragmentState() {
//    resetUsers();
    dateController.text = "";
    deptController.text = "";
    yearController.text = "";
    semesterController.text = "";
    subjectController.text = "";
    messageController.text = "";
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
    buttonActive = false;
    _presenter = new AttendanceFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      _presenter.doFetch(username, auth_token);
    });
  }

  Image loader;

  @override
  void initState() {
    loader = Image.asset(
      "images/loader.gif",
    );
    super.initState();
    new Future.delayed(Duration.zero, () {
      showProgressModal(context);
    });
  }

  @override
  void didChangeDependencies() async {
    await precacheImage(loader.image, context);
    super.didChangeDependencies();
  }

  showProgressModal(context) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(2.0))),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: loader,
                  ),
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          "Please wait...",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Poppins", color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
                          style: new TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
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
                        child: new TextField(
                          enabled: false,
                          style: new TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
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
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
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
                                  style: new TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black,
                                  ),
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
                          style: new TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
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
                          Text(
                            "1",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "2",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "3",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "4",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "5",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "6",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "7",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "8",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                            ),
                          ),
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
                  ]
              ),
            ),
          ),
          new Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15),
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
                        "Take Attendance",
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void buttonPressed() {
    Navigator.push(context,
        MaterialPageRoute(
            builder: (context) =>
                StudentListFragment(
                    pk_table: pk_table, required_timestamp: datetime_column)));
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onFetchError(String errorTxt) {
    Navigator.pop(context);
    _showSnackBar(errorTxt.substring(11));
    print(errorTxt.toString());
    messageController.text = errorTxt.replaceFirst("Exception: ", '');
    setState(() {
      buttonActive = false;
    });
    // TODO: implement onFetchError
  }

  @override
  void onFetchSuccess(res) {
    Navigator.pop(context);
    if (res != "invalid-auth-or-access") {
      preselect(res);
    }
    setState(() {
      buttonActive = true;
    });
  }
}
