import 'package:flutter/material.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      alignment: Alignment(-1, -1),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          Text(
            "Loyola-ICAM College of Engineering and Technology",
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22.0,
              color: Colors.white,
              fontWeight: FontWeight.normal,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          ImageWidget(),
//          LoginInfo(),
          Text(
            "Add Company Footer HERE",
            style: TextStyle(
                fontFamily: 'Segoe',
                fontSize: 10.0,
                fontWeight: FontWeight.w200,
                color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }
}

class ImageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage logoAsset2 = AssetImage('images/licetlogo.png');
    Image logoLicetImage = new Image(
      image: logoAsset2,
    );
    return Container(
      child: logoLicetImage,
      width: 180,
      height: 180,
    );
  }
}