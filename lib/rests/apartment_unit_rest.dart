import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/apartment_unit.dart';

class ApartmentUnitRest extends Api{
  List<ApartmentUnit> parseApartmentUnits(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      return parsed['data'].map<ApartmentUnit>((tagJson) {
        // print('parseApartmentUnits '+tagJson.toString());
        return ApartmentUnit.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<ApartmentUnit>> getApartmentUnits(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmentunits?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseApartmentUnits(response.body);
    } else {
      return null;
    }
  }

  Future<List<ApartmentUnit>> populate(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmentunits/populate?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseApartmentUnits(response.body);
    } else {
      return null;
    }
  }

  Future<List<ApartmentUnit>> number(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmentunits/number?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseApartmentUnits(response.body);
    } else {
      return null;
    }
  }
  Future<ApartmentUnit> show(int id, Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmentunits/$id?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        print('ApartmentUnit show'+parsed['data'].toString());
        return ApartmentUnit.fromMap(parsed['data']);
      }
      return ApartmentUnit.fromMap(parsed);
    }
    return null;
  }
}