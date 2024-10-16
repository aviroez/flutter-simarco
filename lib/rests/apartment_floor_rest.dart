import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/apartment_floor.dart';

class ApartmentFloorRest extends Api{
  List<ApartmentFloor> parseApartmentFloors(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      return parsed['data'].map<ApartmentFloor>((tagJson) {
        return ApartmentFloor.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<ApartmentFloor>> getApartmentFloors(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmentfloors?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseApartmentFloors(response.body);
    } else {
      return null;
    }
  }

  Future<List<ApartmentFloor>> populate(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmentfloors/populate?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseApartmentFloors(response.body);
    } else {
      return null;
    }
  }
}