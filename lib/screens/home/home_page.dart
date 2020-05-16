import 'package:attendance/auth.dart';
import 'package:attendance/data/database_helper.dart';
import 'package:attendance/models/user.dart';
import 'package:attendance/screens/home/AttendanceFragment/AttendanceFragment.dart';
import 'package:attendance/screens/home/settings/SettingsFragment.dart';
import 'package:attendance/screens/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'AttendanceFragment/ModifyAttendanceFragment.dart';
import 'about/AboutFragment.dart';
import 'home_screen_presenter.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class HomeScreen extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Take Attendance", Icons.check),
    new DrawerItem("Modify Attendance", Icons.change_history),
    new DrawerItem("On Duty Entry", Icons.work),
    new DrawerItem("Views", Icons.calendar_today),
    new DrawerItem("Export", Icons.find_in_page),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("About", Icons.info),
    new DrawerItem("Log out", Icons.exit_to_app),
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
  final scaffoldKeyLogout = new GlobalKey<ScaffoldState>();


  HomeScreenState() {
    _presenter = new HomeScreenPresenter(this);
    _presenter.getUserInfo();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.subscribe(this);
  }

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 1:
        return new AttendanceFragment();
      case 2:
        return new ModifyAttendanceFragment();
      case 6:
        return new SettingsFragment();
      case 7:
        return new AboutFragment();
      case 8:
        return Scaffold(
          key: scaffoldKeyLogout,
          body: AlertDialog(
            title: Text('Log out'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Do you want to log out of Communicator?'),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Colors.black38,
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen()));
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  _logout();
                },
              ),
            ],
          ),
        );

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  onAuthStateChanged(AuthState state) {
    if (state == AuthState.LOGGED_OUT) {
      print(context.toString());
      print(context.runtimeType);
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _ctx = context;
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      if (i == 7) {
        drawerOptions.add(
          const Divider(height: 1.0, color: Colors.grey),
        );
      }
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

  Future<void> _logout() async {
    var db = new DatabaseHelper();
    await db.deleteUsers();
    var authStateProvider = new AuthStateProvider();
    authStateProvider.notify(AuthState.LOGGED_OUT);
  }

}