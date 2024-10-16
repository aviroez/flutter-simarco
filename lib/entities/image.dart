import 'dart:convert';
import '../entities/image_pivot.dart';

class Image{
  int id;
  String name;
  String url;
  String alt;
  String slug;
  String driver;
  ImagePivot pivot;

  Image(this.id, this.name, this.url, this.alt, this.slug, this.driver, this.pivot);

  factory Image.fromMap(Map<String, dynamic> data) {
    if (data != null) {
      return getImage(data);
    }
    return null;
  }

  factory Image.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getImage(data);
    }
    return null;
  }

  factory Image.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    return getImage(data);
  }

  factory Image.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getImage(data);
    }

    return Image.fromMap(data);
  }

  static getImage(Map<String, dynamic> data){
    return Image(
      (data['id'] is int) ? data['id'] : int.parse(data['id']),
      data['name'],
      data['url'],
      data['alt'],
      data['slug'],
      data['driver'],
      data['pivot'] != null ? ImagePivot.fromMap(data['pivot']): null,
    );
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'url': url,
    'alt': alt,
    'slug': slug,
    'driver': driver,
  };

}