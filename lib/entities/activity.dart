import 'dart:convert';

class Activity {
  int id;
  int apartment_id;
  String code;
  String name;
  String description;

  Activity(this.id, this.apartment_id, this.code, this.name, this.description);

  factory Activity.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getActivity(json);
    }
    return null;
  }

  static getActivity(data){
    if (data['id'] != null){
      return Activity(
        (data['id'] != null) ? data['id'] : null,
        (data['apartment_id'] != null) ? data['apartment_id'] : null,
        data['code'],
        data['name'],
        data['description'],
      );
    }
    return null;
  }

  factory Activity.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getActivity(data);
    }
    return null;
  }

  factory Activity.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getActivity(data);
    }
    return null;
  }

  factory Activity.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getActivity(json);
    }

    return Activity.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'apartment_id': apartment_id,
    'code': code,
    'name': name,
    'description': description,
  };

}