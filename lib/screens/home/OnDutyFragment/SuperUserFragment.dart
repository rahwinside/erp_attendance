import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'SuperUserStudentListFragment.dart';
import 'superuser_menu_presenter.dart';

var username = "";
var auth_token = "";
var department = "";
var hour = "1";

List<dynamic> final_json_array = new List<dynamic>();
List<dynamic> super_json_array = new List<dynamic>();
List<dynamic> regular_json_array = new List<dynamic>();

// super_json is true if the hour was substituted with a regular hour.
bool super_json = true;

List<String> subject_array = new List<String>();
List<String> pk_table_array = new List<String>();
List<String> required_timestamp_array = new List<String>();

final List<String> year = <String>[
  "I",
  "II",
  "III",
  "IV",
];
final scaffoldKey = new GlobalKey<ScaffoldState>();

final dateFormat = DateFormat("dd.MM.yyyy - EEEE");
var date_fmt_for_API = new DateFormat('yyyy-MM-dd');

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
TextEditingController subjectController = new TextEditingController();
TextEditingController messageController = new TextEditingController();

String pk_table = "";
String required_timestamp = "";
String department_abbrev = "";

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
    implements SuperUserFragmentContract {
  void preselect(dynamic res) {
//    print(res.toString());
    super_json = true;
    final_json_array = new List<dynamic>();
    super_json_array = new List<dynamic>();
    regular_json_array = new List<dynamic>();
    subject_array = new List<String>();
    pk_table_array = new List<String>();
    required_timestamp_array = new List<String>();
    res.forEach((element) {
      if (element["source"] == "super") {
        super_json_array.add(element);
      } else if (element["source"] == "regular") {
        regular_json_array.add(element);
        print("added");
      }
    });

    // rarest case - single elective being substituted with a different hour
    super_json_array.forEach((super_element) {
      regular_json_array.forEach((regular_element) {
        if (super_element['subCode_dept_sem'] ==
            regular_element['subCode_dept_sem']) {
          print("All electives substituted");
          super_json = false;
        }
      });
    });

    if (super_json_array.isEmpty) {
      super_json = false;
    } else if (regular_json_array.isEmpty) {
      super_json = true;
    }

    // final_json_array wil have the regular timetable if an elective/regular
    // hour was substituted with a regular hour
    final_json_array = super_json ? super_json_array : regular_json_array;

    final_json_array.forEach((element) {
      subject_array.add(element["subject_code"].toString().toUpperCase() +
          " - " +
          element["subject_name"].toString());
      pk_table_array.add(element["subCode_dept_sem"].toString());
      required_timestamp_array.add(element["required_timestamp"].toString());
    });

    subjectController.text = subject_array[0];

    print(subject_array);
    print(pk_table_array);
    print(required_timestamp_array);

    setState(() {});
  }

  SuperUserFragmentPresenter _presenter;

  _OnDutyFragmentState() {
//    resetUsers();
    yearController.text = "III";

    var now = new DateTime.now();
    print(now);
    String formattedDate = date_fmt_for_API.format(now);

    dateController.text = dateFormat.format(now);
    deptController.text = "";
    messageController.text = "";
//    subjectController.text = "";
    hourSelected = [true, false, false, false, false, false, false, false];
    buttonActive = false;
    _presenter = new SuperUserFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      department = user.department;
      deptController.text = department;
      if (department == "Information Technology") {
        department_abbrev = "dit";
      }
      _presenter.doFetch(username, auth_token, department_abbrev,
          yearController.text.toString(), formattedDate, "1");
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
                        controller: dateController,
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(0),
                          labelText: "Select date",
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
                          labelText: "Select year",
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
                        "Select hour",
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
                              username,
                              auth_token,
                              department_abbrev,
                              yearController.text.toString(),
                              date_fmt_for_API.format(DateFormat("dd.MM.yyyy")
                                  .parse(dateController.text
                                      .toString()
                                      .split(" ")[0])),
                              (index + 1).toString());
                        },
                      ),
                    ),
                    new Padding(
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
                          labelText: "Select subject",
                          labelStyle: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w200,
                            color: Colors.black,
                          ),
                        ),
                        value: subject_array.isEmpty
                            ? null
                            : subjectController.text,
                        onChanged: (value) {
                          setState(() {
                            pk_table =
                            pk_table_array[subject_array.indexOf(value)];
                            required_timestamp = required_timestamp_array[
                                subject_array.indexOf(value)];
                            subjectController.text = value;
                            buttonActive = true;
                          });
                        },
                        items: subject_array.isEmpty
                            ? null
                            : subject_array.map(
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
            builder: (context) =>
                SuperUserStudentListFragment(
                  pk_table: pk_table,
                  required_timestamp: required_timestamp,
                )));
  }

//  bool get_subject_array_status() {
//    print("getting: " + subject_array.isEmpty.toString() +
//        subjectController.text.toString());
//    return subject_array.isEmpty;
//  }

  void _showSnackBar(String text) {
    scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(text)));
  }

  @override
  void onFetchError(String errorTxt) {
    final_json_array = new List<dynamic>();
    super_json_array = new List<dynamic>();
    regular_json_array = new List<dynamic>();
    messageController.text = errorTxt.replaceFirst("Exception: ", '');
    Navigator.pop(context);
    print(errorTxt);
    setState(() {
      buttonActive = false;
    });
    // TODO: implement onFetchError
  }

  @override
  void onFetchSuccess(res) {
    final_json_array = new List<dynamic>();
    super_json_array = new List<dynamic>();
    regular_json_array = new List<dynamic>();
    subject_array = new List<String>();
    pk_table_array = new List<String>();
    required_timestamp_array = new List<String>();
    Navigator.pop(context);
    messageController.text = "";
    if (res != "invalid-auth-or-access") {
      preselect(res);
    }
    setState(() {
      buttonActive = true;
    });
  }
}
