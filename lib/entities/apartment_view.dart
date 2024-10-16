import 'dart:convert';

import 'package:simarco/utils/helpers.dart';

class ApartmentView {
  int id;
  String name;
  String description;
  double compensation_percent;
  int apartment_id;
  int apartment_tower_id;

  ApartmentView(this.id, this.name, this.description,
      this.compensation_percent, this.apartment_id, this.apartment_tower_id);

  static ApartmentView getApartmentView(Map<String, dynamic> json){
    if (json != null) {
      return ApartmentView(
        (json['id'] is int) ? json['id'] : int.parse(json['id']),
        json['name'],
        json['description'],
        Helpers.toDouble(json['compensation_percent']),
        Helpers.toInt(json['apartment_id']),
        Helpers.toInt(json['apartment_tower_id']),
      );
    }
    return null;
  }

  factory ApartmentView.fromMap(Map<String, dynamic> json) {
    return getApartmentView(json);
  }

  factory ApartmentView.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getApartmentView(data);
    }
    return null;
  }

  factory ApartmentView.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    return getApartmentView(data);
  }

  factory ApartmentView.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getApartmentView(json);
    }

    return ApartmentView.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'compensation_percent': compensation_percent,
    'apartment_id': apartment_id,
    'apartment_tower_id': apartment_tower_id,
  };

}