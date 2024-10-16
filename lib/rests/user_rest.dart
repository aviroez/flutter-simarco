import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:simarco/entities/response_status.dart';
import 'api.dart';
import '../entities/user.dart';

class UserRest extends Api{
  List<User> parseUsers(String responseBody) {
    print('UserRest parseUsers '+responseBody);
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<User>((json) => User.fromMap(json)).toList();
  }

  Future<List<User>> getUsers() async {
    String path = url+'/api/users';
    print('path $path');
    final response = await http.get(path);
    if (response.statusCode == 200) {
      return parseUsers(response.body);
    } else {
      // throw Exception('Unable to fetch products from the REST API');
      return null;
    }
  }

  Future<User> login(String email, String password) async {
    // String path = url+'/login.php?email='+email+'&password='+password;
    String path = url+'/api/login';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    Map<String, String> body = Map<String, String>();
    body.putIfAbsent('email', () => email);
    body.putIfAbsent('password', () => password);
    final response = await http.post(path, headers: headers, body: body);
    print('response:login ${response.body}');
    if (response.statusCode == 200 && response.body != null) {
      return User.fromJsonData(response.body);
    } else {
      // throw Exception('Unable to fetch products from the REST API');
      return null;
    }
  }

  Future<User> update(int id, Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/users/${id}';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.put(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return User.fromMap(parsed['data']);
      }
      return User.fromMap(parsed);
    }
    return null;
  }

  Future<User> password(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/users/passwords';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.put(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return User.fromMap(parsed['data']);
      }
      return User.fromMap(parsed);
    }
    return null;
  }

  Future<User> check(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/users/check';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.put(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return User.fromMap(parsed['data']);
      }
      return User.fromMap(parsed);
    }
    return null;
  }

  Future<ResponseStatus> forgot(String email) async {
    String path = url+'/api/forgot';
    print('path $path');
    Map<String, String> body = Map<String, String>();
    body.putIfAbsent('email', () => email);
    final response = await http.post(path, body: body);
    if (response.statusCode == 200 && response.body != null) {
      return ResponseStatus.fromJson(response.body);
    } else {
      return null;
    }
  }
}