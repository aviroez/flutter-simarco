import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logger/logger.dart';
import 'package:simarco/password.dart';
import 'dart:developer' as developer;
import 'entities/user.dart';
import 'generated/l10n.dart';
import 'rests/user_rest.dart';
import 'sessions.dart';
import 'menu.dart';

class LoginRoute extends StatelessWidget {
  User user;
  String message;

  LoginRoute(this.message);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      title: S.of(context).login,
      home: LoginStatefulWidget(this.message),
    );
  }
}

class LoginStatefulWidget extends StatefulWidget {
  User user;
  String message;

  LoginStatefulWidget(this.message);

  @override
  CustomLoginStatefulWidget createState() => CustomLoginStatefulWidget(this.message);
}

class CustomLoginStatefulWidget extends State<LoginStatefulWidget> {
  User user;
  String message;
  final textEmailController = TextEditingController();
  final textPasswordController = TextEditingController();
  final logger = Logger();
  bool obscureText = true;
  bool loading = false;

  CustomLoginStatefulWidget(this.message);

  @override
  void initState() {
    super.initState();
    Session.getSession().then((map) {
      if (map.containsKey('email')){
        textEmailController.text = map['email'];
      }
      if (map.containsKey('password')){
        textPasswordController.text = map['password'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (message != null){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        var snackBar = SnackBar(content: Text(message));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        message = null;
      });
    }
    Session.parseUser().then((user) {
      if (user != null){
        this.user = user;
        _moveToUserList(context, user);
      }
    });
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
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
                      SizedBox(height: 25),
                      Image.asset("assets/images/ic_simarco.png", width: 100),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textEmailController,
                        // initialValue: isPassword ? 'Password' : 'Email',
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: textPasswordController,
                        obscureText: obscureText,
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blueAccent, width: 1),
                          ),
                          suffixIcon: IconButton(
                            onPressed: (){
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: obscureText ? Icon(Icons.remove_red_eye) : Icon(Icons.remove_red_eye_outlined),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      _submitButton(context),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: (){
                            _moveToResetPassword(context);
                          },
                          child: Text(S.of(context).forgotPassword,
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500
                              )
                          ),
                        ),
                      ),
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
        content: Text(textEmailController.text);
        String email = textEmailController.text;
        String password = textPasswordController.text;
        UserRest userRest = UserRest();
        userRest.login(email, password).then((user) {
          print('login:user: ${user.toJson().toString()}');
          setState(() {
            loading = false;
          });
          if (user != null){
            Session.saveUser(user);
            _moveToUserList(context, user);
          }
          Session.saveSession(email, password);
          var snackBar = SnackBar(content: Text(S.of(context).loginInvalid));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }).catchError((onError){
          setState(() {
            loading = false;
          });
          print('login:user:catchError ${onError.toString()}');
          var snackBar = SnackBar(content: Text(S.of(context).loginInvalid));
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
          S.of(context).login,
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  _moveToUserList(BuildContext context, User user) {
    Route route = MaterialPageRoute(builder: (context) => Menu(user: user));
    return Navigator.pushReplacement(context, route);
  }

  _moveToResetPassword(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PasswordRoute()),
    );
  }

}