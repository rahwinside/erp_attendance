import 'package:attendance/auth.dart';
import 'package:attendance/data/database_helper.dart';
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
    new DrawerItem("About", Icons.info),
    new DrawerItem("Log out", Icons.close),
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen>
    implements HomeScreenContract, AuthStateListener {

  BuildContext _ctx;
  HomeScreenPresenter _presenter;
  String _fullNameText = "Loading...";
  String _deptText = "Loading...";
  String _picURL = "https://weareeverywhere.in/images/profile-pictures/default.jpg";

  final scaffoldKey = new GlobalKey<ScaffoldState>();


  HomeScreenState() {
    _presenter = new HomeScreenPresenter(this);
    _presenter.getUserInfo();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new AttendanceFragment();
      case 1:
        return new Text("Error");
      case 2:
        return new Text("Error");
      case 3:
        _logout();
        return Center(
          child: Text(
            "Logging out...",
            style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w300,
              fontSize: 20,
            ),
          ),
        );
//        return AlertDialog(
//          title: Text('Log out'),
//          content: SingleChildScrollView(
//            child: ListBody(
//              children: <Widget>[
//                Text('Do you want to log out of Communicator?'),
//              ],
//            ),
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text(
//                'No',
//                style: TextStyle(
//                  color: Colors.black38,
//                ),
//              ),
//              onPressed: () {
//                Navigator.of(_ctx).pushReplacementNamed("/home");
//              },
//            ),
//            FlatButton(
//              child: Text('Yes'),
//              onPressed: () {
//                _logout();
//              },
//            ),
//          ],
//        );

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon),
            title: new Text(d.title, style: TextStyle(fontFamily: "Poppins"),),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: new Text(
          widget.drawerItems[_selectedDrawerIndex].title,
          style: TextStyle(
            fontFamily: "Poppins",
          ),
        ),
      ),
      drawer: new Drawer(
        child: SingleChildScrollView(
          child: new Column(
            children: <Widget>[
              new UserAccountsDrawerHeader(
                accountName: new Text(_fullNameText, style: TextStyle(
                    fontFamily: "Poppins", fontWeight: FontWeight.w600)),
                accountEmail: new Text(_deptText, style: TextStyle(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    fontSize: 12)),
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

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_OUT) {
      print(context.toString());
      print(context.runtimeType);
      Navigator.pushNamedAndRemoveUntil(context, '/login', (context) => false);
    }
  }

  Future<void> _logout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
  }

}