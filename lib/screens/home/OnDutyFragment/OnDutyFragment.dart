import 'package:attendance/api/datetime_API.dart';
import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'onduty_presenter.dart';

var username = "";
var auth_token = "";
var hour = "1";

final List<String> year = <String>[
  "I",
  "II",
  "III",
  "IV",
];
final scaffoldKey = new GlobalKey<ScaffoldState>();

final dateFormat = DateFormat("dd.MM.yyyy - EEEE");
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

String pk_table = "";
String required_timestamp = "";

// takeAttendance button is deactivated by default
bool buttonActive = false;

class OnDutyFragment extends StatefulWidget {
  OnDutyFragment({Key key}) : super(key: key);

  @override
  _OnDutyFragmentState createState() {
    return new _OnDutyFragmentState();
  }
}

class _OnDutyFragmentState extends State<OnDutyFragment>
    implements OnDutyFragmentContract {
  void preselect(dynamic res) {
//    dateController.text = res["displaydate"].toString();
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
    semesterController.text = res["semester"].toString();
    subjectController.text = res["subject_code"].toString().toUpperCase() +
        " - " +
        res["subject_name"].toString();
    messageController.text = "";
    required_timestamp = res["required_timestamp"].toString();
    pk_table = res["subCode_dept_sem"].toString().toLowerCase();
    setState(() {});
  }

  OnDutyFragmentPresenter _presenter;

  _OnDutyFragmentState() {
//    resetUsers();
    yearController.text = "I";
    dateController.text = "";
    deptController.text = "";
    semesterController.text = "";
    subjectController.text = "";
    messageController.text = "";
    hourSelected = [true, false, false, false, false, false, false, false];
    buttonActive = false;
    _presenter = new OnDutyFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      DateTimeRestDataSource api = new DateTimeRestDataSource();
      api.getServerClock().then((date_json) {
        dateController.text = date_json["displaydate"];
        _presenter.doFetch(username, auth_token, hour);
      });
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
                    Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: new TextField(
                          enabled: false,
                          controller: deptController,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
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
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 5),
                      child: new DateTimeField(
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          labelText: "Date of class",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                        ),
                        format: dateFormat,
                        initialValue: DateTime.now(),
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime.now());
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5, right: 5),
                      child: new DropdownButtonFormField<String>(
                        isExpanded: true,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          labelText: "Year",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                        ),
                        value: yearController.text,
                        onChanged: (value) {
                          setState(() {
                            yearController.text = value;
                          });
                        },
                        items: year.map(
                              (item) {
                            return DropdownMenuItem(
                              value: item.toString(),
                              child: new Text(
                                item.toString(),
                                style: new TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          },
                        ).toList(),
                      ),
                    ),
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
                          showProgressModal(context);
                          _presenter.doFetch(
                              username, auth_token, (index + 1).toString());
                        },
                      ),
                    ),
                    new Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 5, right: 5),
                        child: TextField(
                          enabled: false,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
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
                        "Update Attendance",
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
//    Navigator.push(
//        context,
//        MaterialPageRoute(
//            builder: (context) =>
//                ModifyStudentListFragment(
//                  pk_table: pk_table,
//                  required_timestamp: required_timestamp,)
//        )
//    );
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onFetchError(String errorTxt) {
    Navigator.pop(context);
    messageController.text = errorTxt.substring(11) + ".";
//    dateController.text = "";
    deptController.text = "";
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
    Navigator.pop(context);
    if (res != "invalid-auth-or-access") {
      preselect(res);
    }
    setState(() {
      buttonActive = true;
    });
  }
}
