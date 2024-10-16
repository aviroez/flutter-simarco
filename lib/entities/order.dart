import 'dart:convert';
import '../entities/customer.dart';
import '../entities/image.dart';
import '../entities/order_installment.dart';
import '../utils/helpers.dart';
import 'apartment.dart';
import 'apartment_unit.dart';

class Order {
  int id;
  int user_id;
  int customer_id;
  int apartment_unit_id;
  String booking_no;
  String order_no;
  String order_date;
  String name;
  String nik;
  String sim;
  String npwp;
  String address_correspondent;
  String address;
  String district;
  String regency;
  String province;
  String country;
  String phone_number;
  String fax;
  String handphone;
  String email;
  int marketing_id;
  double price;
  double tax;
  double discount;
  double total_price;
  double final_price;
  double booking_fee;
  String signature;
  int signature_image_id;
  String status;
  int payment_schema_id;
  int payment_type_id;
  double dp_percent;
  int dp_installment;
  String gender;
  int created_sent;
  int processed_sent;
  double total_paid;
  double remaining_payment;
  String va_mandiri;
  int installment_number;
  int apartment_id;
  int apartment_tower_id;
  String customer_code;
  String apartment_unit_code;
  double gimmick_nominal;
  String gimmick_description;
  String payment_type_code;
  double dp_nominal;
  int cash_number;
  int notify;
  Apartment apartment;
  ApartmentUnit apartment_unit;
  Customer customer;
  List<Image> images;
  List<OrderInstallment> order_installments;

  Order(this.id, this.user_id, this.customer_id, this.apartment_unit_id, this.booking_no,
      this.order_no, this.order_date, this.name, this.nik, this.sim,
      this.npwp, this.address_correspondent, this.address, this.district, this.regency,
      this.province, this.country, this.phone_number, this.fax, this.handphone,
      this.email, this.marketing_id, this.price, this.tax, this.discount,
      this.total_price, this.final_price, this.booking_fee, this.signature, this.signature_image_id,
      this.status, this.payment_schema_id, this.payment_type_id, this.dp_percent, this.dp_installment,
      this.gender, this.created_sent, this.processed_sent, this.total_paid, this.remaining_payment,
      this.va_mandiri, this.installment_number, this.apartment_id, this.apartment_tower_id, this.customer_code,
      this.apartment_unit_code, this.gimmick_nominal, this.gimmick_description, this.payment_type_code, this.dp_nominal,
      this.cash_number, this.notify, this.apartment, this.apartment_unit, this.customer, this.images,
      this.order_installments);

  factory Order.fromMap(Map<String, dynamic> json) {
    if (json != null) {
      return getOrder(json);
    }
    return null;
  }

  static getOrder(data){
    if (data['id'] != null){
      return Order(
        (data['id'] != null) ? data['id'] : null,
        (data['user_id'] != null) ? data['user_id'] : null,
        (data['customer_id'] != null) ? data['customer_id'] : null,
        (data['apartment_unit_id'] != null) ? data['apartment_unit_id'] : null,
        data['booking_no'],

        data['order_no'],
        data['order_date'],
        data['name'],
        data['nik'],
        data['sim'],

        data['npwp'],
        data['address_correspondent'],
        data['address'],
        data['district'],
        data['regency'],

        data['province'],
        data['country'],
        data['phone_number'],
        data['fax'],
        data['handphone'],

        data['email'],
        (data['marketing_id'] != null) ? data['marketing_id'] : null,
        (data['price'] != null) ? Helpers.toDouble(data['price']) : null,
        (data['tax'] != null) ? Helpers.toDouble(data['tax']) : null,
        (data['discount'] != null) ? Helpers.toDouble(data['discount']) : null,

        (data['total_price'] != null) ? Helpers.toDouble(data['total_price']) : null,
        (data['final_price'] != null) ? Helpers.toDouble(data['final_price']) : null,
        (data['booking_fee'] != null) ? Helpers.toDouble(data['booking_fee']) : null,
        data['signature'],
        (data['signature_image_id'] != null) ? Helpers.toInt(data['signature_image_id']) : null,

        data['status'],
        (data['payment_schema_id'] != null) ? Helpers.toInt(data['payment_schema_id']) : null,
        (data['payment_type_id'] != null) ? Helpers.toInt(data['payment_type_id']) : null,
        (data['dp_percent'] != null) ? Helpers.toDouble(data['dp_percent']) : null,
        (data['dp_installment'] != null) ? Helpers.toInt(data['dp_installment']) : null,

        data['gender'],
        (data['created_sent'] != null) ? Helpers.toInt(data['created_sent']) : null,
        (data['processed_sent'] != null) ? Helpers.toInt(data['processed_sent']) : null,
        (data['total_paid'] != null) ? Helpers.toDouble(data['total_paid']) : null,
        (data['remaining_payment'] != null) ? Helpers.toDouble(data['remaining_payment']) : null,

        data['va_mandiri'],
        (data['installment_number'] != null) ? Helpers.toInt(data['installment_number']) : null,
        (data['apartment_id'] != null) ? Helpers.toInt(data['apartment_id']) : null,
        (data['apartment_tower_id'] != null) ? Helpers.toInt(data['apartment_tower_id']) : null,
        data['customer_code'],

        data['apartment_unit_code'],
        data['gimmick_nominal'] ?? null,
        data['gimmic_description'],
        data['payment_type_code'],
        data['dp_nominal'] ?? null,

        data['cash_number'] ?? null,
        data['notify'],
        data['apartment'] != null ? Apartment.fromMap(data['apartment']): null,
        data['apartment_unit'] != null ? ApartmentUnit.fromMap(data['apartment_unit']): null,
        data['customer'] != null ? Customer.fromMap(data['customer']): null,

        data['images'] != null ? data['images'].map<Image>((tagJson) {
          return Image.fromMap(tagJson);
        }).toList() : null,
        data['order_installments'] != null ? data['order_installments'].map<OrderInstallment>((tagJson) {
          return OrderInstallment.fromMap(tagJson);
        }).toList() : null,
      );
    }
    return null;
  }

  factory Order.fromMapData(Map<String, dynamic> json) {
    if (json != null) {
      var data = json['data'];
      return getOrder(data);
    }
    return null;
  }

  factory Order.fromJson(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null){
      return getOrder(data);
    }
    return null;
  }

  factory Order.fromJsonData(String string) {
    Map<String, dynamic> data = jsonDecode(string);
    if (data != null && data['data'] != null){
      var json = data['data'];
      return getOrder(json);
    }

    return Order.fromMap(data);
  }

  Map toJson() => {
    'id': id,
    'user_id': user_id,
    'customer_id': customer_id,
    'apartment_unit_id': apartment_unit_id,
    'booking_no': booking_no,

    'order_no': order_no,
    'order_date': order_date,
    'name': name,
    'nik': nik,
    'sim': sim,

    'npwp': npwp,
    'address_correspondent': address_correspondent,
    'address': address,
    'district': district,
    'regency': regency,

    'province': province,
    'country': country,
    'phone_number': phone_number,
    'fax': fax,
    'handphone': handphone,

    'email': email,
    'marketing_id': marketing_id,
    'price': price,
    'tax': tax,
    'discount': discount,

    'total_price': total_price,
    'final_price': final_price,
    'booking_fee': booking_fee,
    'signature': signature,
    'signature_image_id': signature_image_id,

    'status': status,
    'payment_schema_id': payment_schema_id,
    'payment_type_id': payment_type_id,
    'dp_percent': dp_percent,
    'dp_installment': dp_installment,

    'gender': gender,
    'created_sent': created_sent,
    'processed_sent': processed_sent,
    'total_paid': total_paid,
    'remaining_payment': remaining_payment,

    'va_mandiri': va_mandiri,
    'installment_number': installment_number,
    'apartment_id': apartment_id,
    'apartment_tower_id': apartment_tower_id,

    'customer_code': customer_code,
    'apartment_unit_code': apartment_unit_code,
    'gimmick_nominal': gimmick_nominal,
    'gimmick_description': gimmick_description,
    'payment_type_code': payment_type_code,
    'dp_nominal': dp_nominal,
    'cash_number': cash_number,
    'notify': notify,
  };

}