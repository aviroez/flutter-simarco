import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/event.dart';

class EventRest extends Api{
  List<Event> parseEvents(String responseBody) {
    final parsed = json.decode(responseBody);
    print('parseEvents ${parsed.toString()}');
    if (parsed != null && parsed['data'] != null){
      // if (parsed['data']['data'] != null){
      //   return parsed['data']['data'].map<Event>((tagJson) {
      //     return Event.fromMap(tagJson);
      //   }).toList();
      // }
      return parsed['data'].map<Event>((tagJson) {
        return Event.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<Event>> getEvents(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/events?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseEvents(response.body);
    } else {
      return null;
    }
  }

  Future<Event> add(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/events';
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Event.fromMap(parsed['data']);
      }
      return Event.fromMap(parsed);
    }
    return null;
  }
}