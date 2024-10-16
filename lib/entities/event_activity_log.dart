import 'dart:convert';
import '../utils/helpers.dart';
import 'image.dart';
import 'event.dart';

class EventActivityLog{
  int id;
  int event_activity_id;
  int event_id;
  int activity_id;
  int customer_id;
  int marketing_id;
  double latitude;
  double longitude;
  String location;
  int apartment_id;
  String created_at;
  Event event;
  List<Image> images;

  EventActivityLog(this.id, this.event_activity_id, this.event_id, this.activity_id, this.customer_id, this.marketing_id, this.latitude, this.longitude, this.location, this.apartment_id, this.created_at, this.event, this.images);

  factory EventActivityLog.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getEventActivityLog(json);
    }
    return null;
  }

  static getEventActivityLog(data){
    if (data['id'] != null){
      return EventActivityLog(
        (data['id'] != null) ? data['id'] : null,
        (data['event_activity_id'] != null) ? Helpers.toInt(data['event_activity_id']) : null,
        (data['event_id'] != null) ? Helpers.toInt(data['event_id']) : null,
        (data['activity_id'] != null) ? Helpers.toInt(data['activity_id']) : null,
        (data['customer_id'] != null) ? Helpers.toInt(data['customer_id']) : null,
        (data['marketing_id'] != null) ? Helpers.toInt(data['marketing_id']) : null,
        data['latitude'] != null ? Helpers.toDouble(data['latitude']) : 0,
        data['longitude'] != null ? Helpers.toDouble(data['longitude']) : 0,
        data['location'],
        (data['apartment_id'] != null) ? Helpers.toInt(data['apartment_id']) : null,
        data['created_at'],
        data['event'] != null ? Event.fromMap(data['event']): null,
        data['images'] != null ? data['images'].map<Image>((tagJson) {
          return Image.fromMap(tagJson);
        }).toList() : null,
      );
    }
    return null;
  }

  factory EventActivityLog.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getEventActivityLog(data);
    }
    return null;
  }

  factory EventActivityLog.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getEventActivityLog(data);
    }
    return null;
  }

  factory EventActivityLog.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getEventActivityLog(json);
    }

    return EventActivityLog.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'event_activity_id': event_activity_id,
    'event_id': event_id,
    'activity_id': activity_id,
    'customer_id': customer_id,
    'marketing_id': marketing_id,
    'latitude': latitude,
    'longitude': longitude,
    'location': location,
    'apartment_id': apartment_id,
    'event': event,
    'images': images,
  };
}