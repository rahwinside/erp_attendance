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
            padding: EdgeInsets.only(bottom: 2),
            child: Container(
              decoration: BoxDecoration(
                color: value ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(2),
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
          new Divider(height: 1.0, color: Colors.grey),
        ],
      ),
    );
  }
}

class StudentListFragment extends StatefulWidget {
  final String timestamp;

  // constructor
  StudentListFragment({
    Key key,
    @required this.timestamp,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _StudentListFragmentState();
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


  StudentListFragmentPresenter _presenter;

  _StudentListFragmentState() {
    _presenter = new StudentListFragmentPresenter(this);
    var db = new DatabaseHelper();
    db.getFirstUser().then((User user) {
      username = user.username;
      auth_token = user.auth_token;
      _presenter.doFetch(username, auth_token, "dummytimestamp");
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
    setState(() {});
  }

  void upload() {
    upload_list.clear();
    print(rolls.length);
    for (var i = 0; i < rolls.length; i++) {
      String x = '{register_no: "' + full_rolls[i].toString() +
          '", full_name: "' + names[i] + '", status: ' +
          (_isSelected[i] ? "1" : "0") + "}";
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
      body: Padding(
        padding: const EdgeInsets.only(
            top: 10.0, left: 15, right: 15, bottom: 10),
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 9,
              child: SingleChildScrollView(
                  child: loopable()
              ),
            ),
            new RaisedButton(
                key: null,
                onPressed: upload,
//                  onPressed: buttonPressed,
                color: Colors.deepPurple,
                splashColor: Colors.purple,
                elevation: 5.0,
                child: new Text(
                  "Upload",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                  ),
                )
            ),
          ],
        ),
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
