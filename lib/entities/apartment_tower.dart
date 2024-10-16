import 'dart:convert';

class ApartmentTower{
  int id;
  String name;
  String code;
  String address;
  String description;
  String latitude;
  String longitude;
  int apartment_id;

  ApartmentTower(this.id, this.name, this.code, this.address, this.description,
      // this.latitude, this.longitude,
      this.apartment_id);

  static getApartmentTower(Map<String, dynamic> json){
    if (json != null && json['id'] != null) {
      return ApartmentTower(
        (json['id'] is int) ? json['id'] : int.parse(json['id']),
        json['name'],
        json['code'],
        json['address'],
        json['description'],
        // (json['latitude'] is double) ? json['latitude'] : double.parse(json['latitude']),
        // (json['longitude'] is double) ? json['longitude'] : double.parse(json['longitude']),
        (json['apartment_id'] is int) ? json['apartment_id'] : int.parse(json['apartment_id']),
      );
    }
    return null;
  }

  factory ApartmentTower.fromMap(Map<String, dynamic> json) {
    return getApartmentTower(json);
  }

  factory ApartmentTower.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getApartmentTower(data);
    }
    return null;
  }

  factory ApartmentTower.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    return getApartmentTower(data);
  }

  factory ApartmentTower.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getApartmentTower(userData);
    }

    return ApartmentTower.fromMap(data);
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
  };

}