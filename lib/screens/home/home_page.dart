import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment.dart';
import 'package:flutter/material.dart';

import 'home_screen_presenter.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Attendance", Icons.access_alarms),
    new DrawerItem("Reports", Icons.report),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("Logout", Icons.close),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> implements HomeScreenContract {

  HomeScreenPresenter _presenter;
  String _fullNameText = "Loading...";
  String _deptText = "Loading...";
  String _picURL = "https://weareeverywhere.in/images/profile-pictures/default.jpg";

  HomeScreenState() {
    _presenter = new HomeScreenPresenter(this);
    _presenter.getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    int _selectedDrawerIndex = 0;

    _getDrawerItemWidget(int pos) {
      switch (pos) {
        case 0:
          return new AttendanceFragment();
//      case 1:
//        return new SecondFragment();
//      case 2:
//        return new ThirdFragment();

        default:
          return new Text("Error");
      }
    }

    _onSelectItem(int index) {
      setState(() => _selectedDrawerIndex = index);
      Navigator.of(context).pop(); // close the drawer
    }

    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(
                accountName: new Text(_fullNameText),
              accountEmail: new Text(_deptText),
              currentAccountPicture: CircleAvatar(
                radius: 60.0,
                backgroundColor: const Color(0xFF778899),
                backgroundImage: NetworkImage(_picURL), // for Network image
              ),
            ),
            new Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }

  @override
  void onDisplayUserInfo(User user) {
    setState(() {
      _fullNameText = user.full_name;
      _deptText = user.department;
      _picURL = user.picture_url;
    });
  }

  @override
  void onErrorUserInfo() {
    setState(() {
      _fullNameText = 'There was an error retrieving your info';
      _deptText = 'There was an error retrieving your info';
      _picURL = 'There was an error retrieving your info';
    });
  }

}