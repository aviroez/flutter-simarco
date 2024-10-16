import 'dart:convert';
import '../entities/apartment.dart';
import '../utils/helpers.dart';

class Event {
  int id;
  int apartment_id;
  String name;
  String address;
  String description;
  String start_date;
  String end_date;
  double latitude;
  double longitude;
  Apartment apartment;

  Event(this.id, this.apartment_id, this.name, this.address, this.description, this.start_date, this.end_date, this.latitude, this.longitude, this.apartment);

  factory Event.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getEvent(json);
    }
    return null;
  }

  static getEvent(data){
    if (data['id'] != null){
      return Event(
        (data['id'] != null) ? data['id'] : null,
        (data['apartment_id'] != null) ? Helpers.toInt(data['apartment_id']) : null,
        data['name'],
        data['address'],
        data['description'],
        data['start_date'],
        data['end_date'],
        data['latitude'] != null ? Helpers.toDouble(data['latitude']) : 0,
        data['longitude'] != null ? Helpers.toDouble(data['longitude']) : 0,
        data['apartment'] != null ? Apartment.fromMap(data['apartment']): null,
      );
    }
    return null;
  }

  factory Event.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getEvent(data);
    }
    return null;
  }

  factory Event.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getEvent(data);
    }
    return null;
  }

  factory Event.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getEvent(json);
    }

    return Event.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'apartment_id': apartment_id,
    'name': name,
    'address': address,
    'description': description,
    'start_date': start_date,
    'end_date': end_date,
    'latitude': latitude,
    'longitude': longitude,
  };

}