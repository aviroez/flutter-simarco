import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/apartment_tower.dart';

class ApartmentTowerRest extends Api{
  List<ApartmentTower> parseApartmentTowers(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      return parsed['data'].map<ApartmentTower>((tagJson) {
        return ApartmentTower.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<ApartmentTower>> getApartmentTowers(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/apartmenttowers?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseApartmentTowers(response.body);
    } else {
      return null;
    }
  }
}