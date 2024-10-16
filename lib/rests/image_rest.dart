import 'dart:io';import 'dart:async';
import 'package:http/http.dart' as http;
import 'api.dart';
import '../entities/order.dart';

class ImageRest extends Api{

  Future<Order> order(int id, File file, Map<String, String> query, String code) async {
    String token = await getToken();
    String queryString = Uri(queryParameters: query).query;

    String path = url+'/api/images/$id/order?$queryString';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');

    var request = http.MultipartRequest('POST', Uri.parse(path));
    request.headers.addAll(headers);
    request.files.add(
        http.MultipartFile(
            'file[]',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split("/").last
        )
    );
    // request.fields.addAll(other)
    // var response = await request.send();
    http.Response response = await http.Response.fromStream(await request.send());
    print("ImageRest order: ${response.statusCode}");
    print("ImageRest order: ${response.body}");
    if (response.statusCode == 200) {
      return Order.fromJsonData(response.body);
    } else {
      return null;
    }
  }

  Future<Order> eventactivitylog(int id, File file, Map<String, String> query, String code) async {
    String token = await getToken();
    String queryString = Uri(queryParameters: query).query;

    String path = url+'/api/images/$id/eventactivitylog?$queryString';
    print('path $path');
    Map<String, String> headers = Map<String, String>();
    headers.putIfAbsent(HttpHeaders.authorizationHeader, () => 'Bearer $token');

    var request = http.MultipartRequest('POST', Uri.parse(path));
    request.headers.addAll(headers);
    request.files.add(
        http.MultipartFile(
            'images[]',
            file.readAsBytes().asStream(),
            file.lengthSync(),
            filename: file.path.split("/").last
        )
    );
    // request.fields.addAll(other)
    // var response = await request.send();
    http.Response response = await http.Response.fromStream(await request.send());
    if (response.statusCode == 200) {
      return Order.fromJsonData(response.body);
    } else {
      return null;
    }
  }
}