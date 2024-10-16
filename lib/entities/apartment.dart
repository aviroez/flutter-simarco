import 'dart:convert';
import '../utils/helpers.dart';
import 'image.dart';

class Apartment{
  int id;
  String name;
  String code;
  String full_name;
  String address;
  String description;
  double latitude;
  double longitude;
  String status;
  List<Image> images;

  Apartment(this.id, this.name, this.code, this.full_name, this.address,
      this.description, this.latitude, this.longitude, this.status, this.images);

  static getApartment(Map<String, dynamic> data){
    if (data['id'] != null && data.containsKey('id')){
      return Apartment(
        (data['id'] is int) ? data['id'] : int.parse(data['id']),
        data['name'],
        data['code'],
        data['full_name'],
        data['address'],
        data['description'],
        Helpers.toDouble(data['latitude']),
        Helpers.toDouble(data['longitude']),
        data['status'],
        data['images'] != null ? data['images'].map<Image>((tagJson) {
          return Image.fromMap(tagJson);
        }).toList() : null,
      );
    }
    return null;
  }

  factory Apartment.fromMap(Map<String, dynamic> json) {
    return getApartment(json);
  }

  factory Apartment.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getApartment(data);
    }
    return null;
  }

  factory Apartment.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    return getApartment(data);
  }

  factory Apartment.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getApartment(userData);
    }

    return Apartment.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'full_name': full_name,
    'address': address,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'status': status,
    'images': images,
  };

}