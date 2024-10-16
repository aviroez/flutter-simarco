import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/customer.dart';

class CustomerRest extends Api{
  List<Customer> parseCustomers(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){
      if (parsed['data']['data'] != null){
        return parsed['data']['data'].map<Customer>((tagJson) {
          return Customer.fromMap(tagJson);
        }).toList();
      }
      return parsed['data'].map<Customer>((tagJson) {
        return Customer.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<Customer>> getCustomers(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/customers?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseCustomers(response.body);
    } else {
      return null;
    }
  }

  Future<Customer> update(int id, Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/customers/${id}';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.put(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      print('path body ${response.body.toString()}');
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Customer.fromMap(parsed['data']);
      }
      return Customer.fromMap(parsed);
    }
    return null;
  }
}