import 'package:flutter/material.dart';

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
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new _StudentListFragmentState();
  }
}

class _StudentListFragmentState extends State<StudentListFragment> {
  List<Widget> list = new List<Widget>();
  dynamic names = ["5040 | Navin C", "5041 | B", "5042 | C"];
  bool _isSelected = false;

  Column loopable() {
    for (var i = 0; i < names.length; i++) {
      list.add(LabeledCheckbox(
        label: names[i],
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        value: _isSelected,
        onChanged: (bool newValue) {
          setState(() {
            _isSelected = newValue;
          });
        },
      ));
    }
    return new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clickable"),
      ),
      body: Center(
          child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: LabeledCheckbox(
                label: names[0],
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                value: _isSelected,
                onChanged: (bool newValue) {
                  setState(() {
                    _isSelected = newValue;
                  });
                },
              ))),
    );
  }
}
