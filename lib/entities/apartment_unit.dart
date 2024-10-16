import 'dart:convert';
import 'apartment.dart';
import 'apartment_floor.dart';
import 'apartment_tower.dart';
import 'apartment_type.dart';
import 'apartment_view.dart';

class ApartmentUnit{
  int id;
  String name;
  String code;
  String desc;
  String unit_number;
  double markup_percent;
  double price;
  double discount;
  double tax;
  double total_price;
  double price_cash;
  double price_installment;
  double price_kpa;
  double tax_cash;
  double tax_installment;
  double tax_kpa;
  double total_price_cash;
  double total_price_installment;
  double total_price_kpa;
  double markup_price;
  int group_unit;
  int apartment_id;
  int apartment_tower_id;
  int apartment_type_id;
  int apartment_view_id;
  int apartment_floor_id;
  String status;
  int position_number;
  String apartment_type_desc;
  Apartment apartment;
  ApartmentTower apartment_tower;
  ApartmentType apartment_type;
  ApartmentView apartment_view;
  ApartmentFloor apartment_floor;
  // Customer customer;

  ApartmentUnit(this.id, this.name, this.code, this.desc, this.unit_number,
      this.markup_percent, this.price, this.discount, this.tax, this.total_price,
      this.price_cash, this.price_installment, this.price_kpa, this.tax_cash, this.tax_installment,
      this.tax_kpa, this.total_price_cash, this.total_price_installment, this.total_price_kpa, this.markup_price,
      this.group_unit, this.apartment_id, this.apartment_tower_id, this.apartment_type_id, this.apartment_view_id,
      this.apartment_floor_id, this.status, this.position_number, this.apartment_type_desc, this.apartment,
      this.apartment_tower, this.apartment_type, this.apartment_view, this.apartment_floor);

  static getApartmentUnit(Map<String, dynamic> json){
    if (json != null && json['id'] != null) {
      return ApartmentUnit(
        (json['id'] is int) ? json['id'] : int.parse(json['id']),
        json['name'],
        json['code'],
        json['desc'],
        json['unit_number'],
        (json['markup_percent'] != null && json['markup_percent'] is double) ? json['markup_percent'] : 0,
        (json['price'] != null && json['price'] is double) ? json['price'] : 0,
        (json['discount'] != null && json['discount'] is double) ? json['discount'] : 0,
        (json['tax'] != null && json['tax'] is double) ? json['tax'] : 0,
        (json['total_price'] != null && json['total_price'] is double) ? json['total_price'] : 0,
        (json['price_cash'] != null && json['price_cash'] is double) ? json['price_cash'] : 0,
        (json['price_installment'] != null && json['price_installment'] is double) ? json['price_installment'] : 0,
        (json['price_kpa'] != null && json['price_kpa'] is double) ? json['price_kpa'] : 0,
        (json['tax_cash'] != null && json['tax_cash'] is double) ? json['tax_cash'] : 0,
        (json['tax_installment'] != null && json['tax_installment'] is double) ? json['tax_installment'] : 0,
        (json['tax_kpa'] != null && json['tax_kpa'] is double) ? json['tax_kpa'] : 0,
        (json['total_price_cash'] != null && json['total_price_cash'] is double) ? json['total_price_cash'] : 0,
        (json['total_price_installment'] != null && json['total_price_installment'] is double) ? json['total_price_installment'] : 0,
        (json['total_price_kpa'] != null && json['total_price_kpa']  is double) ? json['total_price_kpa'] : 0,
        (json['markup_price'] != null && json['markup_price'] is double) ? json['markup_price'] : 0,
        (json['group_unit'] != null && json['group_unit'] is int) ? json['group_unit'] : 0,
        (json['apartment_id'] != null && json['apartment_id'] is int) ? json['apartment_id'] : null,
        (json['apartment_tower_id'] != null && json['apartment_tower_id'] is int) ? json['apartment_tower_id'] : null,
        (json['apartment_type_id'] != null && json['apartment_type_id'] is int) ? json['apartment_type_id'] : null,
        (json['apartment_view_id'] != null && json['apartment_view_id'] is int) ? json['apartment_view_id'] : null,
        (json['apartment_floor_id'] != null && json['apartment_floor_id'] is int) ? json['apartment_floor_id'] : null,
        json['status'],
        (json['position_number'] != null && json['position_number'] is int) ? json['position_number'] : null,
        json['apartment_type_desc'],
        json['apartment'] != null ? Apartment.fromMap(json['apartment']): null,
        json['apartment_tower'] != null ? ApartmentTower.fromMap(json['apartment_tower']): null,
        json['apartment_type'] != null ? ApartmentType.fromMap(json['apartment_type']): null,
        json['apartment_view'] != null ? ApartmentView.fromMap(json['apartment_view']): null,
        json['apartment_floor'] != null ? ApartmentFloor.fromMap(json['apartment_floor']): null,
      );
    }
    return null;
  }

  factory ApartmentUnit.fromMap(Map<String, dynamic> json) {
    return getApartmentUnit(json);
  }

  factory ApartmentUnit.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getApartmentUnit(data);
    }
    return null;
  }

  factory ApartmentUnit.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getApartmentUnit(data);
    }
    return null;
  }

  factory ApartmentUnit.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    // print('fromJsonData '+data['data'].toString());
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getApartmentUnit(userData);
    }

    return ApartmentUnit.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'name': name,
    'code': code,
    'desc': desc,
    'unit_number': unit_number,
    'markup_percent': markup_percent,
    'price': price,
    'discount': discount,
    'tax': tax,
    'total_price': total_price,
    'price_cash': price_cash,
    'price_installment': price_installment,
    'price_kpa': price_kpa,
    'tax_cash': tax_cash,
    'tax_installment': tax_installment,
    'tax_kpa': tax_kpa,
    'total_price_cash': total_price_cash,
    'total_price_installment': total_price_installment,
    'total_price_kpa': total_price_kpa,
    'markup_price': markup_price,
    'group_unit': group_unit,
    'apartment_id': apartment_id,
    'apartment_tower_id': apartment_tower_id,
    'apartment_type_id': apartment_type_id,
    'apartment_view_id': apartment_view_id,
    'apartment_floor_id': apartment_floor_id,
    'status': status,
    'position_number': position_number,
    'apartment_type_desc': apartment_type_desc,
    'apartment': apartment,
    'apartment_tower': apartment_tower,
    'apartment_type': apartment_type,
    'apartment_view': apartment_view,
    'apartment_floor': apartment_floor,
  };

}