import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/customer_lead.dart';

class CustomerLeadRest extends Api{
  List<CustomerLead> parseCustomerLeads(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null){
      if (parsed['data'] != null){
        if (parsed['data']['data'] != null){
          return parsed['data']['data'].map<CustomerLead>((tagJson) {
            return CustomerLead.fromMap(tagJson);
          }).toList();
        }

        return parsed['data'].map<CustomerLead>((tagJson) {
          return CustomerLead.fromMap(tagJson);
        }).toList();
      }

      return parsed.map<CustomerLead>((tagJson) {
        return CustomerLead.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<CustomerLead>> getCustomerLeads(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/customerleads?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseCustomerLeads(response.body);
    } else {
      return null;
    }
  }

  Future<CustomerLead> add(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/customerleads';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return CustomerLead.fromMap(parsed['data']);
      }
      return CustomerLead.fromMap(parsed);
    }
    return null;
  }

  Future<CustomerLead> update(int id, Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/customerleads/${id}';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.put(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return CustomerLead.fromMap(parsed['data']);
      }
      return CustomerLead.fromMap(parsed);
    }
    return null;
  }
}