import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:simarco/login.dart';
import 'dart:developer' as developer;
import 'entities/user.dart';
import 'rests/user_rest.dart';
import 'sessions.dart';
import 'menu.dart';

class PasswordRoute extends StatelessWidget {

  PasswordRoute();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "User List",
      home: PasswordStatefulWidget(),
    );
  }
}

class PasswordStatefulWidget extends StatefulWidget {
  PasswordStatefulWidget();

  @override
  CustomPasswordStatefulWidget createState() => CustomPasswordStatefulWidget();
}

class CustomPasswordStatefulWidget extends State<PasswordStatefulWidget> {
  final textEmailController = TextEditingController();
  final logger = Logger();
  bool obscureText = true;
  bool loading = false;

  CustomPasswordStatefulWidget();

  @override
  Widget build(BuildContext context) {
    Session.getSession().then((map) {
      if (map.containsKey('email')){
        textEmailController.text = map['email'];
      }
    });
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          color: Colors.white,
          onPressed: (){
            Route route = MaterialPageRoute(builder: (context) => LoginRoute(null));
            return Navigator.pushReplacement(context, route);
          },
        ),
        title: Text("Lupa Password"),
      ),
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            alignment: Alignment.bottomCenter,
            image: AssetImage("assets/images/image_background_pp_properti_gradasi.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Theme(
                  data: Theme.of(context).copyWith(
                    primaryColor: Colors.blueAccent,
                    primaryColorDark: Colors.blue,
                    accentColor: Colors.lightBlueAccent,
                  ),
                  child: loading ?
                  Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Image.asset("assets/images/ic_simarco.png", width: 100),
                          SizedBox(height: 25),
                          CircularProgressIndicator()
                        ]
                    ),
                  ) :
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 10),
                      Image.asset("assets/images/ic_simarco.png", width: 100),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: textEmailController,
                        // initialValue: isPassword ? 'Password' : 'Email',
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 15),
                      _submitButton(context),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return InkWell(
      onTap: (){
        setState(() {
          loading = true;
        });
        String email = textEmailController.text;
        UserRest userRest = UserRest();
        userRest.forgot(email).then((result) {
          setState(() {
            loading = false;
          });
          // var snackBar = SnackBar(content: Text(result.message));
          // ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _moveToLogin(context, result.message);
        }).catchError((onError){
          setState(() {
            loading = false;
          });
          print('login:user:catchError ${onError.toString()}');
          var snackBar = SnackBar(content: Text(onError.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
        // logger.i(user);
      },
      onLongPress: (){
        developer.log('login', name: textEmailController.text);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2
              )
            ],
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.blue, Colors.blueAccent]
            )
        ),
        child: Text(
          'Lupa Password',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }


  _moveToLogin(BuildContext context, String message) {
    Route route = MaterialPageRoute(builder: (context) => LoginRoute(message));
    return Navigator.pushReplacement(context, route);
  }

}