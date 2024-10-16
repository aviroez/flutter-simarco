import 'dart:convert';
import '../utils/helpers.dart';

class OrderInstallment {
  int id;
  int payment_schema_id;
  int payment_type_id;
  int order_id;
  String order_no;
  String description;
  int number;
  String status;
  String due_date;
  String payment_date;
  double price;
  double fine;
  double payment_nominal;
  double remaining_payment;
  String payment_to;
  String payment_status;
  String type;
  String midtrans_token;

  OrderInstallment(this.id, this.payment_schema_id, this.payment_type_id, this.order_id,
      this.order_no, this.description, this.number, this.status, this.due_date, this.payment_date,
      this.price, this.fine, this.payment_nominal, this.remaining_payment, this.payment_to,
      this.payment_status, this.type, this.midtrans_token);

  factory OrderInstallment.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getOrderInstallment(json);
    }
    return null;
  }

  static getOrderInstallment(data){
    if (data['id'] != null){
      return OrderInstallment(
        (data['id'] != null) ? data['id'] : null,
        (data['payment_schema_id'] != null) ? data['payment_schema_id'] : null,
        (data['payment_type_id'] != null) ? data['payment_type_id'] : null,
        (data['order_id'] != null) ? data['order_id'] : null,
        data['order_no'],

        data['description'],
        data['number'],
        data['status'],
        data['due_date'],
        data['payment_date'],

        (data['price'] != null) ? Helpers.toDouble(data['price']) : null,
        (data['fine'] != null) ? Helpers.toDouble(data['fine']) : null,
        (data['payment_nominal'] != null) ? Helpers.toDouble(data['payment_nominal']) : null,
        (data['remaining_payment'] != null) ? Helpers.toDouble(data['remaining_payment']) : null,
        data['payment_to'],

        data['payment_status'],
        data['type'],
        data['midtrans_token'],
      );
    }
    return null;
  }

  factory OrderInstallment.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getOrderInstallment(data);
    }
    return null;
  }

  factory OrderInstallment.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getOrderInstallment(data);
    }
    return null;
  }

  factory OrderInstallment.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getOrderInstallment(json);
    }

    return OrderInstallment.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'payment_schema_id': payment_schema_id,
    'payment_type_id': payment_type_id,
    'order_id': order_id,
    'order_no': order_no,

    'description': description,
    'number': number,
    'status': status,
    'due_date': due_date,
    'payment_date': payment_date,

    'price': price,
    'fine': fine,
    'payment_nominal': payment_nominal,
    'remaining_payment': remaining_payment,
    'payment_to': payment_to,

    'payment_status': payment_status,
    'type': type,
    'midtrans_token': midtrans_token,
  };

}