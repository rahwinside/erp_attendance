import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


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
final List<bool> isSelected = [
  false,
  false,
  false,
  false,
  false,
  false,
  false,
  false
];

List<String> semesterController;

void preselect() {
  semesterController = year1;
  if (_season == "odd") {
    _valueSem = year1[0];
  }
  else {
    _valueSem = year1[1];
  }
  _valueDept = department[0];
  _valueYear = year[0];
  _valueSubject = subject[0];
}

class AttendanceFragment extends StatefulWidget {
  AttendanceFragment({Key key}) : super(key: key);

  @override
  _AttendanceFragmentState createState() {
    preselect();
    return new _AttendanceFragmentState();
  }
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
            children: <Widget>[
              new DateTimeField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: "Class on",
                  labelStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w300,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.redAccent,
                  ),
                  border: OutlineInputBorder(
                    gapPadding: 1.0,
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                format: dateFormat,
                onShowPicker: (context, currentValue) {
                  return showDatePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime.now());
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: new Text(
                  "Department",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: new DropdownButton<String>(
                  isExpanded: true,
                  style: new TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF202020),
                    fontWeight: FontWeight.w300,
                  ),
                  value: _valueDept,
                  onChanged: (value) {
                    setState(() {
                      _valueDept = value;
                    });
                  },
                  items: department.map(
                        (item) {
                      return DropdownMenuItem(
                        value: item,
                        child: new Text(item),
                      );
                    },
                  ).toList(),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 5),
                            child: new Text(
                              "Year",
                              style: new TextStyle(
                                  fontSize: 12.0,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: new BoxDecoration(
                              border: new Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  5.0)),
                            ),
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              style: new TextStyle(
                                fontSize: 15,
                                color: const Color(0xFF202020),
                                fontWeight: FontWeight.w300,
                              ),
                              value: _valueYear,
                              onChanged: (value) {
                                setState(() {
                                  _valueYear = value;
                                  if (value == "I") {
                                    if (_season == "odd") {
                                      _valueSem = "01";
                                    }
                                    else {
                                      _valueSem = "02";
                                    }
                                    semesterController = year1;
                                  }
                                  else if (value == "II") {
                                    if (_season == "odd") {
                                      _valueSem = "03";
                                    }
                                    else {
                                      _valueSem = "04";
                                    }
                                    semesterController = year2;
                                  }
                                  else if (value == "III") {
                                    if (_season == "odd") {
                                      _valueSem = "05";
                                    }
                                    else {
                                      _valueSem = "06";
                                    }
                                    semesterController = year3;
                                  }
                                  else if (value == "IV") {
                                    if (_season == "odd") {
                                      _valueSem = "07";
                                    }
                                    else {
                                      _valueSem = "08";
                                    }
                                    semesterController = year4;
                                  }
                                });
                              },
                              items: year.map(
                                    (item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: new Text(item),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(right: 5)),
                    new Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 5, right: 5, bottom: 5),
                            child: new Text(
                              "Semester",
                              style: new TextStyle(
                                  fontSize: 12.0,
                                  color: const Color(0xFF000000),
                                  fontWeight: FontWeight.w200,
                                  fontFamily: "Roboto"),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10, right: 10),
                            decoration: new BoxDecoration(
                              border: new Border.all(color: Colors.black38),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  5.0)),
                            ),
                            child: new DropdownButton<String>(
                              isExpanded: true,
                              style: new TextStyle(
                                fontSize: 15,
                                color: const Color(0xFF202020),
                                fontWeight: FontWeight.w300,
                              ),
                              value: _valueSem,
                              onChanged: (value) {
                                setState(() {
                                  _valueSem = value;
                                });
                              },
                              items: semesterController.map(
                                    (item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: new Text(item),
                                  );
                                },
                              ).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: new Text(
                  "Subject",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: new DropdownButton<String>(
                  isExpanded: true,
                  style: new TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF202020),
                    fontWeight: FontWeight.w300,
                  ),
                  value: _valueSubject,
                  onChanged: (value) {
                    setState(() {
                      _valueSubject = value;
                    });
                  },
                  items: subject.map(
                        (item) {
                      return DropdownMenuItem(
                        value: item,
                        child: new Text(item),
                      );
                    },
                  ).toList(),
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: new Text(
                  "Select hours (you can select more than one)",
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.w200,
                      fontFamily: "Roboto"),
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
                  onPressed: (int index) {
                    int count = 0;
                    isSelected.forEach((bool val) {
                      if (val) count++;
                    });

                    if (isSelected[index] && count < 2) return;

                    setState(() {
                      isSelected[index] = !isSelected[index];
                    });
                  },
                  isSelected: isSelected,
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
                      fontSize: 15,
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.normal,
                    ),
                  ))
            ]),
      ),
    );
  }

  void buttonPressed() {}

  void popupButtonSelected(String value) {}
}
