import 'dart:convert';

import 'package:simarco/utils/helpers.dart';

class ApartmentType{
  int id;
  String name;
  String description;
  double surfaces_nett;
  double surfaces_gross;
  double price_per_m2;
  double prepayment_furnish;
  int bedroom_count;
  int apartment_id;
  int apartment_tower_id;

  ApartmentType(this.id, this.name, this.description,
      this.surfaces_nett, this.surfaces_gross, this.price_per_m2, this.prepayment_furnish,
      this.bedroom_count, this.apartment_id, this.apartment_tower_id);

  static getApartmentType(Map<String, dynamic> json){
    if (json != null && json['id'] != null) {
      return ApartmentType(
        (json['id'] is int) ? json['id'] : int.parse(json['id']),
        json['name'],
        json['description'],
        Helpers.toDouble(json['surfaces_nett']),
        Helpers.toDouble(json['surfaces_gross']),
        Helpers.toDouble(json['price_per_m2']),
        Helpers.toDouble(json['prepayment_furnish']),
        Helpers.toInt(json['bedroom_count']),
        Helpers.toInt(json['apartment_id']),
        Helpers.toInt(json['apartment_tower_id']),
      );
    }
  }

  factory ApartmentType.fromMap(Map<String, dynamic> json) {
    return getApartmentType(json);
  }

  factory ApartmentType.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getApartmentType(data);
    }
    return null;
  }

  factory ApartmentType.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getApartmentType(data);
    }
    return null;
  }

  factory ApartmentType.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getApartmentType(json);
    }

    return ApartmentType.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'surfaces_nett': surfaces_nett,
    'surfaces_gross': surfaces_gross,
    'price_per_m2': price_per_m2,
    'prepayment_furnish': prepayment_furnish,
    'bedroom_count': bedroom_count,
    'apartment_id': apartment_id,
    'apartment_tower_id': apartment_tower_id,
  };

}