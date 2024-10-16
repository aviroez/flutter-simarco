import 'dart:convert';
import '../utils/helpers.dart';

class Customer{
  int id;
  String name;
  String nik;
  String sim;
  String npwp;
  String address;
  String district;
  String regency;
  String province;
  String country;
  String phone_number;
  String fax;
  String handphone;
  String email;
  int validity;
  String address_correspondent;
  String gender;
  String birth_date;
  int apartment_id;
  int marketing_id;
  int event_id;
  int activity_id;

  Customer(this.id, this.name, this.nik, this.sim, this.npwp,
      this.address, this.district, this.regency, this.province, this.country,
      this.fax, this.handphone, this.email, this.validity, this.apartment_id,
      this.marketing_id, this.address_correspondent, this.gender, this.birth_date, this.event_id,
      this.activity_id);

  static getCustomer(data){
    if (data != null && data['id'] != null){
      return Customer(
        (data['id'] != null) ? Helpers.toInt(data['id']) : null,
        data['name'],
        data['nik'],
        data['sim'],
        data['npwp'],
        data['address'],
        data['district'],
        data['regency'],
        data['province'],
        data['country'],
        data['fax'],
        data['handphone'],
        data['email'],
        (data['validity'] != null) ? data['validity'] : null,
        (data['apartment_id'] != null) ? data['apartment_id'] : null,
        (data['marketing_id'] != null) ? data['marketing_id'] : null,
        data['address_correspondent'],
        data['gender'],
        data['birth_date'],
        (data['event_id'] != null) ? data['event_id'] : null,
        (data['activity_id'] != null) ? data['activity_id'] : null,
      );
    }
  }

  factory Customer.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getCustomer(json);
    }
    return null;
  }

  factory Customer.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getCustomer(data);
    }
    return null;
  }

  factory Customer.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getCustomer(data);
    }
    return null;
  }

  factory Customer.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getCustomer(userData);
    }

    return Customer.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'nik': nik,
    'sim': sim,
    'npwp': npwp,

    'address': address,
    'district': district,
    'regency': regency,
    'province': province,
    'country': country,

    'fax': fax,
    'handphone': handphone,
    'email': email,
    'validity': validity,
    'apartment_id': apartment_id,

    'marketing_id': marketing_id,
    'address_correspondent': address_correspondent,
    'gender': gender,
    'birth_date': birth_date,
    'event_id': event_id,

    'activity_id': activity_id,
  };

}