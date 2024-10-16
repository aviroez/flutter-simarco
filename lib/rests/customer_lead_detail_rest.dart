import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/customer_lead_detail.dart';

class CustomerLeadDetailRest extends Api{
  List<CustomerLeadDetail> parseCustomerLeadDetails(String responseBody) {
    final parsed = json.decode(responseBody);
    print('parseCustomerLeadDetails '+parsed.toString());
    if (parsed != null){
      if (parsed['data'] != null){
        print('parseCustomerLeadDetails data '+parsed['data'].toString());
        if (parsed['data']['data'] != null){
          print('parseCustomerLeadDetails data data '+parsed['data']['data'].toString());
          return parsed['data']['data'].map<CustomerLeadDetail>((tagJson) {
            return CustomerLeadDetail.fromMap(tagJson);
          }).toList();
        }

        return parsed['data'].map<CustomerLeadDetail>((tagJson) {
          return CustomerLeadDetail.fromMap(tagJson);
        }).toList();
      }

      return parsed.map<CustomerLeadDetail>((tagJson) {
        return CustomerLeadDetail.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<CustomerLeadDetail>> getCustomerLeadDetails(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/customerleaddetails?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseCustomerLeadDetails(response.body);
    } else {
      return null;
    }
  }

  Future<CustomerLeadDetail> add(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/customerleaddetails';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return CustomerLeadDetail.fromMap(parsed['data']);
      }
      return CustomerLeadDetail.fromMap(parsed);
    }
    return null;
  }

  Future<CustomerLeadDetail> last(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/customerleaddetails/last?$queryString';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return CustomerLeadDetail.fromMap(parsed['data']);
      }
      return CustomerLeadDetail.fromMap(parsed);
    }
    return null;
  }
}