import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/apartment.dart';

class ApartmentRest extends Api{
  List<Apartment> parseApartments(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      return parsed['data'].map<Apartment>((tagJson) {
        return Apartment.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  getApartments(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartments?'+queryString;
    print('path: $path');
    print('path:token $token');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    return await http.get(path, headers: headers);
    // return response;
    // if (response.statusCode == 200) {
    //   return parseApartments(response.body);
    // } else if (response.statusCode == 401) {
    //   return null;
    // } else {
    //   return null;
    // }
  }
}