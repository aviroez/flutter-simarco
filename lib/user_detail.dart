import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'entities/user.dart';

class UserDetail extends StatelessWidget{

  final User user;

  UserDetail({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.email),
      ),
      body: Container(
        height: double.maxFinite,
        child: new Stack(
          //alignment:new Alignment(x, y)
          children: <Widget>[
            Text(user.name, style: TextStyle(fontSize: 18)),
            // Text(user.email, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }

}