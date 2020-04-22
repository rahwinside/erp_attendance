import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class AttendanceFragment extends StatefulWidget {
  AttendanceFragment({Key key}) : super(key: key);

  @override
  _AttendanceFragmentState createState() => new _AttendanceFragmentState();
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
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: new DropdownButton<String>(
                  isExpanded: true,
                  onChanged: popupButtonSelected,
                  value: "Child 1",
                  style: new TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF202020),
                    fontWeight: FontWeight.w300,
                  ),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(
                        value: "Child 1",
                        child: const Text("Information Technology")),
                    const DropdownMenuItem<String>(
                        value: "Child 2", child: const Text("Child 2")),
                    const DropdownMenuItem<String>(
                        value: "Child 3", child: const Text("Child 3")),
                  ],
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
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          onChanged: popupButtonSelected,
                          value: "Child 1",
                          style: new TextStyle(
                            fontSize: 15,
                            color: const Color(0xFF202020),
                            fontWeight: FontWeight.w300,
                          ),
                          items: <DropdownMenuItem<String>>[
                            const DropdownMenuItem<String>(
                                value: "Child 1", child: const Text("II")),
                            const DropdownMenuItem<String>(
                                value: "Child 2", child: const Text("Child 2")),
                            const DropdownMenuItem<String>(
                                value: "Child 3", child: const Text("Child 3")),
                          ],
                        ),
                      ),
                    ),
                    new Padding(padding: EdgeInsets.only(right: 5)),
                    new Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: new BoxDecoration(
                          border: new Border.all(color: Colors.black38),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        child: new DropdownButton<String>(
                          isExpanded: true,
                          onChanged: popupButtonSelected,
                          value: "Child 1",
                          style: new TextStyle(
                            fontSize: 15,
                            color: const Color(0xFF202020),
                            fontWeight: FontWeight.w300,
                          ),
                          items: <DropdownMenuItem<String>>[
                            const DropdownMenuItem<String>(
                                value: "Child 1", child: const Text("04")),
                            const DropdownMenuItem<String>(
                                value: "Child 2", child: const Text("Child 2")),
                            const DropdownMenuItem<String>(
                                value: "Child 3", child: const Text("Child 3")),
                          ],
                        ),
                      ),
                    ),
                  ]),
              new Padding(
                padding: EdgeInsets.only(top: 10),
              ),
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                decoration: new BoxDecoration(
                  border: new Border.all(color: Colors.black38),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                ),
                child: new DropdownButton<String>(
                  isExpanded: true,
                  onChanged: popupButtonSelected,
                  value: "Child 1",
                  style: new TextStyle(
                    fontSize: 15,
                    color: const Color(0xFF202020),
                    fontWeight: FontWeight.w300,
                  ),
                  items: <DropdownMenuItem<String>>[
                    const DropdownMenuItem<String>(
                        value: "Child 1", child: const Text("Data Structures")),
                    const DropdownMenuItem<String>(
                        value: "Child 2", child: const Text("Child 2")),
                    const DropdownMenuItem<String>(
                        value: "Child 3", child: const Text("Child 3")),
                  ],
                ),
              ),
              new Padding(
                padding: EdgeInsets.only(top: 10),
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
