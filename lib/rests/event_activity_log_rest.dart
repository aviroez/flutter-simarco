import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/event_activity_log.dart';

class EventActivityLogRest extends Api{
  List<EventActivityLog> parseEventActivityLogs(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      // if (parsed['data']['data'] != null){
      //   return parsed['data']['data'].map<EventActivityLog>((tagJson) {
      //     return EventActivityLog.fromMap(tagJson);
      //   }).toList();
      // }
      return parsed['data'].map<EventActivityLog>((tagJson) {
        return EventActivityLog.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<EventActivityLog>> get(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/eventactivitylogs?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseEventActivityLogs(response.body);
    } else {
      return null;
    }
  }

  Future<EventActivityLog> add(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/eventactivitylogs';
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return EventActivityLog.fromMap(parsed['data']);
      }
      return EventActivityLog.fromMap(parsed);
    }
    return null;
  }
}