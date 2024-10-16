import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../entities/user.dart';

class Api {
  get url => DotEnv().env['API'];
  String token;

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs != null && prefs.containsKey('user')) {
      String json = prefs.get('user');
      // print('getToken '+json);
      User user = User.fromJson(json);
      return user.api_token ?? null;
    }
    return null;
  }
}