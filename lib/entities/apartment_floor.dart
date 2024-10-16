import 'dart:convert';
import 'apartment_unit.dart';

class ApartmentFloor{
  int id;
  String name;
  String code;
  String address;
  String description;
  String latitude;
  String longitude;
  int apartment_id;
  List<ApartmentUnit> apartment_units = [];

  ApartmentFloor(this.id, this.name, this.code, this.address, this.description,
      // this.latitude, this.longitude,
      this.apartment_id,
      this.apartment_units);

  static getApartmentFloor(Map<String, dynamic> json){
    if (json != null) {
      return ApartmentFloor(
        (json['id'] is int) ? json['id'] : int.parse(json['id']),
        json['name'],
        json['code'],
        json['address'],
        json['description'],
        // (json['latitude'] is double) ? json['latitude'] : double.parse(json['latitude']),
        // (json['longitude'] is double) ? json['longitude'] : double.parse(json['longitude']),
        (json['apartment_id'] is int) ? json['apartment_id'] : int.parse(json['apartment_id']),
        // json["apartment_units"] != null ? List<ApartmentUnit>.from(json["apartment_units"].map((x)
        // {
        //   print('ApartmentFloor.fromMap x '+x.toString());
        //   return ApartmentUnit.fromJson(x);
        // })) : null,
        json["apartment_units"] != null ? json['apartment_units'].map<ApartmentUnit>((tagJson) {
          // print('ApartmentFloor.fromMap '+tagJson.toString());
          return ApartmentUnit.fromMap(tagJson);
        }).toList() : null,
      );
    }
    return null;
  }

  factory ApartmentFloor.fromMap(Map<String, dynamic> json) {
    return getApartmentFloor(json);
  }

  factory ApartmentFloor.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getApartmentFloor(data);
    }
    return null;
  }

  factory ApartmentFloor.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getApartmentFloor(data);
    }
    return null;
  }

  factory ApartmentFloor.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getApartmentFloor(userData);
    }

    return ApartmentFloor.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'address': address,
    'description': description,
    'latitude': latitude,
    'longitude': longitude,
    'apartment_id': apartment_id,
    'apartment_units': apartment_units,
  };

}