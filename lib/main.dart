import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:new_version/new_version.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:catcher/catcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:package_info/package_info.dart';
import 'generated/l10n.dart';
import 'rests/user_rest.dart';
import 'utils/helpers.dart';
import 'menu.dart';
import 'sessions.dart';
import 'entities/user.dart';
import 'login.dart';
import 'constants.dart';

Future main() async {
  await DotEnv().load('.env');
  customReportAction();
  // runApp(new MaterialApp(
  //   home: new MyApp(),
  // ));
  runApp(
      MyApp()
  );
}

void customReportAction() {
  Catcher(MyApp(), enableLogger: true);
}

MyGlobals myGlobals = MyGlobals();
class MyGlobals {
  GlobalKey _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey();
  }
  GlobalKey get scaffoldKey => _scaffoldKey;
}

class MyApp extends StatelessWidget {
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
      title: Constants.appName,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyHomePage> {
  String appName;
  String packageName;
  String version;
  String buildNumber;
  bool firstLoad = true;

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    if (firstLoad && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkVersion(context);
        setState(() {
          firstLoad = false;
        });
      });
    }
    return Scaffold(
      key: myGlobals.scaffoldKey,
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/ic_simarco.png"),
            fit: BoxFit.fitWidth,
            scale: 0.5,
          ),
        ),
        child: (version != null) ? Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text('$appName v$version'),
          ],
        ) : Container(),
      ),
    );
  }

  void startTimer(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      navigateUser(context); //It will redirect  after 3 seconds
    });
  }

  void navigateUser(BuildContext context) async{
    Map<String, String> body = new Map();
    UserRest().check(body).then((user) {
      if (user != null){
        Session.saveUser(user);
        Route route = MaterialPageRoute(builder: (context) => Menu(user: user));
        return Navigator.pushReplacement(context, route);
      } else {
        Route route = MaterialPageRoute(builder: (context) => LoginRoute(null));
        return Navigator.pushReplacement(context, route);
      }
    }).catchError((onError){
      Route route = MaterialPageRoute(builder: (context) => LoginRoute(null));
      return Navigator.pushReplacement(context, route);
    });
  }

  void checkVersion(BuildContext context) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      packageName = packageInfo.packageName;
      version = packageInfo.version;
      buildNumber = packageInfo.buildNumber;
    });

    var newVersion = NewVersion(
      context: context,
      iOSId: packageName,
      androidId: packageName,
      dismissAction: (){

      },
    );
    VersionStatus versionStatus = await newVersion.getVersionStatus();
    print('version: ${versionStatus.storeVersion}:${versionStatus.localVersion}');
    var appStoreLink = versionStatus.appStoreLink;

    if (mounted){
      if (checkVersionStatusUpdate(versionStatus)){
        showUpdateDialog(context, versionStatus);
      } else {
        navigateUser(context);
      }
    }
  }

  void showUpdateDialog(BuildContext context, VersionStatus versionStatus) async {
    final title = Text(S.of(context).updateAvailable);
    final content = Text(
      S.of(context).youCanNowUpdate(versionStatus.localVersion, versionStatus.storeVersion)
      // 'You can now update this app from ${versionStatus.localVersion} to ${versionStatus.storeVersion}',
    );
    final updateText = Text(S.of(context).update);
    final updateAction = () {
      _launchAppStore(versionStatus.appStoreLink);
      Navigator.of(context, rootNavigator: true).pop();
    };
    final platform = Theme.of(context).platform;
    showDialog(
      context: myGlobals.scaffoldKey.currentContext,
      // context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        if (platform == TargetPlatform.android){
          return AlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              // FlatButton(
              //   child: dismissText,
              //   onPressed: dismissAction,
              // ),
              FlatButton(
                child: updateText,
                onPressed: updateAction,
              ),
            ],
          );
        } else {
          return CupertinoAlertDialog(
            title: title,
            content: content,
            actions: <Widget>[
              // CupertinoDialogAction(
              //   child: dismissText,
              //   onPressed: dismissAction,
              // ),
              CupertinoDialogAction(
                child: updateText,
                onPressed: updateAction,
              ),
            ],
          );
        }
      },
    );
  }

  // Launches the Apple App Store or Google Play Store page for the app.
  void _launchAppStore(String appStoreLink) async {
    if (await canLaunch(appStoreLink)) {
      await launch(appStoreLink);
    } else {
      throw 'Could not launch appStoreLink';
    }
  }

  bool checkVersionStatusUpdate(VersionStatus versionStatus){
    if (versionStatus.storeVersion != null && versionStatus.localVersion != null){
      List<String> storeVersion = versionStatus.storeVersion.split('.');
      List<String> localVersion = versionStatus.localVersion.split('.');
      if (storeVersion.length > localVersion.length){
        while(storeVersion.length != localVersion.length){
          localVersion.add('0');
        }
      } else if (localVersion.length > storeVersion.length){
        while(storeVersion.length != localVersion.length){
          storeVersion.add('0');
        }
      }

      for (var i = 0; i < storeVersion.length; i++){
        if (Helpers.toInt(storeVersion[i]) > Helpers.toInt(localVersion[i])){
          return true;
        }
      }
    }

    return false;
  }
}