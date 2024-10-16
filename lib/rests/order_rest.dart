import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/order.dart';

class OrderRest extends Api{
  List<Order> parseOrders(String responseBody) {
    final parsed = json.decode(responseBody);
    if (parsed != null && parsed['data'] != null){

      if (parsed['data']['data'] != null){
        return parsed['data']['data'].map<Order>((tagJson) {
          print('parseOrders data data '+tagJson.toString());
          return Order.fromMap(tagJson);
        }).toList();
      }
      return parsed['data'].map<Order>((tagJson) {
        print('parseOrders data '+tagJson.toString());
        return Order.fromMap(tagJson);
      }).toList();
    }
    return null;
  }

  Future<List<Order>> getOrders(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/orders?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseOrders(response.body);
    } else {
      return null;
    }
  }

  Future<List<Order>> populate(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/orders/populate?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseOrders(response.body);
    } else {
      return null;
    }
  }

  Future<List<Order>> number(Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/orders/number?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      return parseOrders(response.body);
    } else {
      return null;
    }
  }
  Future<Order> show(int id, Map<String, String> query) async {
    String token = await getToken();

    String queryString = Uri(queryParameters: query).query;
    String path = url+'/api/orders/$id?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        print('Order show'+parsed['data'].toString());
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }

  Future<Order> order(Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/orders';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }

  Future<Order> last(Map<String, String> query) async {
    String token = await getToken();
    String queryString = Uri(queryParameters: query).query;

    String path = url+'/api/orders/last?'+queryString;
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.get(path, headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }

  Future<Order> identity(int id, Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/orders/${id}/identity';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    print('identity path ${path}');
    body.forEach((k,v) => print('identity body ${k}: ${v}'));
    print('identity response ${response.body.toString()}');
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      print('identity ${parsed.toString()}');
      if (parsed != null && parsed['data'] != null){
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }

  Future<Order> installments(int id, Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/orders/${id}/installments';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }

  Future<Order> process(int id, Map<String, String> body) async {
    String token = await getToken();

    String path = url+'/api/orders/${id}/process';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.post(path, headers: headers, body: body);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }

  Future<Order> delete(int id) async {
    String token = await getToken();

    String path = url+'/api/orders/${id}';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');
    final response = await http.delete(path, headers: headers);
    if (response.statusCode == 200) {
      final parsed = json.decode(response.body);
      if (parsed != null && parsed['data'] != null){
        return Order.fromMap(parsed['data']);
      }
      return Order.fromMap(parsed);
    }
    return null;
  }
}