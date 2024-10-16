import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/activity.dart';

class ActivityRest extends Api{
  List<Activity> parseActivities(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      // if (parsed['data']['data'] != null){
      //   return parsed['data']['data'].map<Activity>((tagJson) {
      //     return Activity.fromMap(tagJson);
      //   }).toList();
      // }
      return parsed['data'].map<Activity>((tagJson) {
        return Activity.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<Activity>> getActivities(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/activities?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseActivities(response.body);
    } else {
      return null;
    }
  }
}