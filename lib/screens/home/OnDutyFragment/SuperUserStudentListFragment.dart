import 'dart:async';
import 'dart:convert';

import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:flutter/material.dart';

import 'superuser_studlist_presenter.dart';
import 'superuser_upload_rest_dest.dart';

var username = "";
var auth_token = "";
final scaffoldKey = new GlobalKey<ScaffoldState>();

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.labelname,
    this.labelroll,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String labelname;
  final String labelroll;
  final EdgeInsets padding;
  final bool value;
  final Function onChanged;

  dynamic getGradient() {
    if (value == null)
      return LinearGradient(
        begin: Alignment(-0.97, 0.24),
        end: Alignment(-0.35, 0.21),
        colors: [const Color(0xff2f1f86), const Color(0xff674ef2)],
        stops: [0.0, 1.0],
      );
    else
      return value
          ? LinearGradient(
              begin: Alignment(-0.97, 0.24),
              end: Alignment(-0.35, 0.21),
              colors: [const Color(0xff38837b), const Color(0xff2ac0b1)],
              stops: [0.0, 1.0],
            )
          : LinearGradient(
              begin: Alignment(-0.97, 0.24),
              end: Alignment(-0.35, 0.21),
              colors: [const Color(0xffa8193d), const Color(0xffff3366)],
              stops: [0.0, 1.0],
            );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (value != null) onChanged(!value);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Container(
              decoration: BoxDecoration(
                gradient: getGradient(),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Expanded(
                        child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Container(
//                              color: Colors.deepPurple,
                            child: Text(
                              labelroll,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width / 8,
                          ),
                        ),
                        Wrap(
                          children: <Widget>[
                            Text(
                              labelname,
                              style: new TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 17,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                    Checkbox(
                      tristate: true,
                      focusColor: Colors.orange,
                      hoverColor: Colors.white12,
                      checkColor: Colors.green,
                      activeColor: Colors.white,
                      value: value,
                      onChanged: (bool newValue) {
                        onChanged(newValue);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SuperUserStudentListFragment extends StatefulWidget {
  final String pk_table;
  final String required_timestamp;

  // constructor
  SuperUserStudentListFragment({
    Key key,
    @required this.pk_table,
    @required this.required_timestamp,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _SuperUserStudentListFragmentState(pk_table, required_timestamp);
  }
}

class _SuperUserStudentListFragmentState
    extends State<SuperUserStudentListFragment>
    implements SuperUserStudentListFragmentContract {
  List<Widget> list = new List<Widget>();

//  List upload_list = [];
  List names = [];
  List rolls = [];
  List full_rolls = [];
  List _isSelected = [];
  bool uploadActive = false;
  String pk_table, required_timestamp;
  int presentCounter, absentCounter, onDutyCounter;

  SuperUserStudentListFragmentPresenter _presenter;

  _SuperUserStudentListFragmentState(String pk_table,
      String required_timestamp) {
    presentCounter = 0;
    absentCounter = 0;
    onDutyCounter = 0;
    this.pk_table = pk_table;
    this.required_timestamp = required_timestamp;
    _presenter = new SuperUserStudentListFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      _presenter.doFetch(username, auth_token, pk_table, required_timestamp);
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

  Column loopable() {
    list.clear();
    list.add(new Padding(padding: EdgeInsets.only(top: 15)));
    for (var i = 0; i < names.length; i++) {
      list.add(LabeledCheckbox(
        labelroll: rolls[i],
        labelname: names[i],
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        value: _isSelected[i],
        onChanged: (bool newValue) {
          setState(() {
            _isSelected[i] = newValue;
            presentCounter = 0;
            absentCounter = 0;
            onDutyCounter = 0;
            _isSelected.forEach((status) {
              if (status == true) {
                presentCounter += 1;
              } else if (status == false) {
                absentCounter += 1;
              } else {
                onDutyCounter += 1;
              }
            });
          });
        },
      ));
    }
    return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list);
  }

  list_adapter(dynamic res) {
    res.forEach((student) {
      full_rolls.add(student["register_no"].toString());
      rolls.add(student["register_no"].toString().substring(8));
      names.add(student["full_name"].toString());
      if (student["status"] == "1") {
        _isSelected.add(true);
        presentCounter++;
      } else if (student["status"] == "0") {
        _isSelected.add(false);
        absentCounter++;
      } else if (student["status"] == "2") {
        _isSelected.add(null);
        onDutyCounter++;
      }
    });

    uploadActive = true;
    setState(() {});
  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  String getStatusFromSelected(int i) {
    if (_isSelected[i] == null)
      return "2";
    else
      return _isSelected[i] ? "1" : "0";
  }

  void upload() {
    showProgressModal(context);
    Map<String, String> upload_json = {};
    for (var i = 0; i < rolls.length; i++) {
      upload_json[full_rolls[i].toString()] =
          getStatusFromSelected(i).toString();
    }
    SuperUserUploadAttendanceRest API = new SuperUserUploadAttendanceRest();
    API
        .upload(username, auth_token, pk_table, required_timestamp,
            json.encode(upload_json).toString())
        .then((res) {
      print(res.toString());
      Navigator.pop(context);
      _showSnackBar("Changes committed.");
      new Timer(const Duration(seconds: 1), () => Navigator.pop(context));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Superuser Attendance",
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 87,
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: SingleChildScrollView(child: loopable()),
            ),
          ),
          Expanded(
            flex: 13,
            child: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: new BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: SingleChildScrollView(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            uploadActive
                                ? "Present: " + presentCounter.toString()
                                : "",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          new Text(
                            uploadActive
                                ? "Absent: " + absentCounter.toString()
                                : "",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          new Text(
                            uploadActive
                                ? "On Duty: " + onDutyCounter.toString()
                                : "",
                            style: new TextStyle(
                              fontFamily: "Poppins",
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: new RaisedButton(
                        key: null,
                        onPressed: uploadActive ? upload : null,
                        color: Colors.white,
                        splashColor: Colors.deepPurpleAccent,
                        elevation: 5.0,
                        child: new Text(
                          "Commit",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void onFetchError(String errorTxt) {
    Navigator.pop(context);
    print(errorTxt);
  }

  @override
  void onFetchSuccess(dynamic res) {
//    print(res.toString());
    Navigator.pop(context);
    list_adapter(res);
  }
}
