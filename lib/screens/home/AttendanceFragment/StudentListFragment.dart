import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment/student_presenter.dart';
import 'package:flutter/material.dart';

var username = "";
var auth_token = "";

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    this.label,
    this.padding,
    this.value,
    this.onChanged,
  });

  final String label;
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
          Container(
            color: value ? Colors.green : Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                      child: Text(
                        label,
                        style: new TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          color: Colors.white,
                        ),
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
  dynamic names = [];
  dynamic rolls = [];
  dynamic _isSelected = [];


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
        label: rolls[i] + " | " + names[i],
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
      rolls.add(student["register_no"].toString().substring(8));
      names.add(student["full_name"].toString());
      _isSelected.add(false);
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mark Attendance"),
      ),
      body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(child: loopable()),
          )
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
