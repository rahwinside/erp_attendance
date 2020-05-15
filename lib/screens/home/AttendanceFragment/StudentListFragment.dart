import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment/student_presenter.dart';
import 'package:flutter/material.dart';

var username = "";
var auth_token = "";

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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Container(
              decoration: BoxDecoration(
                gradient: value
                    ? LinearGradient(
                  begin: Alignment(-0.97, 0.24),
                  end: Alignment(-0.35, 0.21),
                  colors: [
                    const Color(0xff38837b),
                    const Color(0xff2ac0b1)
                  ],
                  stops: [0.0, 1.0],
                )
                    : LinearGradient(
                  begin: Alignment(-0.97, 0.24),
                  end: Alignment(-0.35, 0.21),
                  colors: [
                    const Color(0xffa8193d),
                    const Color(0xffff3366)
                  ],
                  stops: [0.0, 1.0],
                ),
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
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width / 8,
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

class StudentListFragment extends StatefulWidget {
  final String pk_table;

  // constructor
  StudentListFragment({
    Key key,
    @required this.pk_table,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _StudentListFragmentState(pk_table);
  }
}

class _StudentListFragmentState extends State<StudentListFragment>
    implements StudentListFragmentContract {
  List<Widget> list = new List<Widget>();
  List upload_list = [];
  List names = [];
  List rolls = [];
  List full_rolls = [];
  List _isSelected = [];
  bool uploadActive = false;
  String pk_table;
  int presentCounter, absentCounter;

  StudentListFragmentPresenter _presenter;

  _StudentListFragmentState(String pk_table) {
    presentCounter = 0;
    absentCounter = 0;
    this.pk_table = pk_table;
    _presenter = new StudentListFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      _presenter.doFetch(username, auth_token, pk_table);
    });
  }

  Column loopable() {
    list.clear();
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
            _isSelected.forEach((status) {
              if (status) {
                presentCounter += 1;
              }
              else {
                absentCounter += 1;
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
      _isSelected.add(false);
    });
    uploadActive = true;
    absentCounter = res.length;
    setState(() {});
  }

  void upload() {
    upload_list.clear();
    print(rolls.length);
    for (var i = 0; i < rolls.length; i++) {
      String x = '{"register_no": "' +
          full_rolls[i].toString() +
          '", "full_name": "' +
          names[i] +
          '", "status": ' +
          (_isSelected[i] ? "1" : "0") +
          "}";
      upload_list.add(x.toString());
    }
    print(upload_list.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 10.0, left: 15, right: 15, bottom: 10),
              child: SingleChildScrollView(child: loopable()),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.only(
                  left: 15, right: 15),
              decoration: new BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 5,
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
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: new RaisedButton(
                        key: null,
                        onPressed: uploadActive ? upload : null,
//                  onPressed: buttonPressed,
                        color: Colors.white,
                        splashColor: Colors.deepPurpleAccent,
                        elevation: 5.0,
                        child: new Text(
                          "Upload",
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
    // TODO: implement onFetchError
    print(errorTxt);
  }

  @override
  void onFetchSuccess(dynamic res) {
//    print(res.toString());
    print(res.runtimeType);
    list_adapter(res);
  }
}
