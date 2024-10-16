import 'dart:convert';

class PaymentSchema{
  int id;
  String name;
  String code;
  String desc;
  String unit_number;
  String status;
  String apartment_type_desc;

  PaymentSchema(this.id, this.name, this.code, this.desc, this.unit_number,
      this.status,
      this.apartment_type_desc);

  static getPaymentSchema(Map<String, dynamic> json){
    if (json != null) {
      return PaymentSchema(
        (json['id'] is int) ? json['id'] : int.parse(json['id']),
        json['name'],
        json['code'],
        json['desc'],
        json['unit_number'],
        json['status'],
        json['apartment_type_desc'],
      );
    }
    return null;
  }

  factory PaymentSchema.fromMap(Map<String, dynamic> json) {
    return getPaymentSchema(json);
  }

  factory PaymentSchema.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getPaymentSchema(data);
    }
    return null;
  }

  factory PaymentSchema.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getPaymentSchema(data);
    }
    return null;
  }

  factory PaymentSchema.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getPaymentSchema(userData);
    }

    return PaymentSchema.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'desc': desc,
    'unit_number': unit_number,
    'status': status,
    'apartment_type_desc': apartment_type_desc,
  };

}