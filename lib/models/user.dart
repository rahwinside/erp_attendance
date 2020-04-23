class User {
  String _username;
  String _auth_token;
  String _full_name;
  String _department;
  String _picture_url;

  User(this._username, this._auth_token, this._full_name, this._department,
      this._picture_url);

  User.map(dynamic obj) {
    this._username = obj["username"];
    this._auth_token = obj["auth_token"];
    this._full_name = obj["full_name"];
    this._department = obj["department"];
    this._picture_url = obj["picture_url"];
  }

  String get username => _username;

  String get auth_token => _auth_token;

  String get full_name => _full_name;

  String get department => _department;

  String get picture_url => _picture_url;

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();
    map["username"] = _username;
    map["auth_token"] = _auth_token;
    map["full_name"] = _full_name;
    map["department"] = _department;
    map["picture_url"] = _picture_url;

    return map;
  }
}
