import 'dart:convert';
import '../utils/helpers.dart';

class CustomerLeadDetail{
  int id;
  String classification;
  String response;
  String type;
  String description;
  String product;
  double price;
  String unit;
  String buy_date;
  int customer_lead_id;

  CustomerLeadDetail(this.id, this.classification, this.response, this.type, this.description,
      this.product, this.price, this.unit, this.buy_date, this.customer_lead_id);

  static getCustomerLeadDetail(data){
    if (data != null && data['id'] != null){
      return CustomerLeadDetail(
        (data['id'] is int) ? data['id'] : int.parse(data['id']),
        data['classification'],
        data['response'],
        data['type'],
        data['description'],
        data['product'],
        (data['price'] != null) ? Helpers.toDouble(data['price']) : null,
        data['unit'],
        data['buy_date'],
        (data['customer_lead_id'] is int) ? data['customer_lead_id'] : null,
      );
    }
  }

  factory CustomerLeadDetail.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getCustomerLeadDetail(json);
    }
    return null;
  }

  factory CustomerLeadDetail.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getCustomerLeadDetail(data);
    }
    return null;
  }

  factory CustomerLeadDetail.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getCustomerLeadDetail(data);
    }
    return null;
  }

  factory CustomerLeadDetail.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var userData = data['data'];
      return getCustomerLeadDetail(userData);
    }

    return CustomerLeadDetail.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'classification': classification,
    'response': response,
    'type': type,
    'description': description,

    'product': product,
    'price': price,
    'unit': unit,
    'buy_date': buy_date,
    'customer_lead_id': customer_lead_id,
  };

}