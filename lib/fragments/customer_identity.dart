import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl/intl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../generated/l10n.dart';
import '../utils/helpers.dart';
import '../entities/customer_lead_join.dart';
import '../entities/customer.dart';
import '../entities/customer_lead.dart';
import '../rests/customer_lead_rest.dart';
import '../rests/customer_rest.dart';
import '../rests/order_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_unit.dart';
import '../entities/order.dart';
import '../entities/user.dart';
import '../menu.dart';

class CustomerIdentites extends StatelessWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;

  CustomerIdentites(this.user, this.apartment, this.parent);

  @override
  Widget build(BuildContext context) {
    return PaymentSchemaStatefulWidget(this.user, this.apartment, this.parent);
  }
}
class PaymentSchemaStatefulWidget extends StatefulWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;
  PaymentSchemaStatefulWidget(this.user, this.apartment, this.parent);

  @override
  _PaymentSchemaStatefulWidget createState() => _PaymentSchemaStatefulWidget(this.user, this.apartment, this.parent);
}

class _PaymentSchemaStatefulWidget extends State<PaymentSchemaStatefulWidget> {
  final User user;
  Apartment apartment;
  ApartmentTower apartment_tower;
  ApartmentUnit apartment_unit;
  Order order;
  Customer _customer;
  CustomerLead _customer_lead;
  CustomerLeadJoin _customer_lead_join;
  CustomMenuStatefulWidget parent;
  List<ApartmentTower> _apartment_towers = [];
  List<Customer> _customers = [];
  List<CustomerLead> _customer_leads = [];
  List<CustomerLeadJoin> _customer_lead_joins = [];
  String handphoneValue = '';
  String handphoneCountryCode = 'ID';
  String handphoneDialCode = '62';
  PhoneContact _contact;
  var regExp = RegExp(r'[^0-9]');
  var _gender = 'm';
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  _PaymentSchemaStatefulWidget(this.user, this.apartment, this.parent);

  TextEditingController textFullName = TextEditingController();
  TextEditingController textNik = TextEditingController();
  TextEditingController textNpwp = TextEditingController();
  TextEditingController textHandphone = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textAlamatLengkap = TextEditingController();
  TextEditingController textAlamatDomisili = TextEditingController();

  @override
  void initState() {
    super.initState();

    order = this.parent.order;
    if (order != null) {
      Map<String, String> query = Map();
      query.putIfAbsent("status_in[0]", () => "booked");
      query.putIfAbsent("status_in[1]", () => "approved");
      query.putIfAbsent("status_in[2]", () => "sp1");
      query.putIfAbsent("status_in[3]", () => "sp2");
      query.putIfAbsent("status_in[4]", () => "sp3");
      query.putIfAbsent("with[0]", () => "apartment_unit.apartment_tower.apartment");
      query.putIfAbsent("with[1]", () => "apartment_unit.apartment_type");
      query.putIfAbsent("with[2]", () => "apartment_unit.apartment_floor");
      query.putIfAbsent("with[3]", () => "apartment_unit.apartment_view");
      query.putIfAbsent("with[4]", () => "payment_type");
      query.putIfAbsent("with[5]", () => "payment_schema");
      query.putIfAbsent("with[6]", () => "order_installments.order_installment_fines");
      query.putIfAbsent("with[7]", () => "order_installments.order_installment_payments");
      query.putIfAbsent("with[8]", () => "customer");
      OrderRest().show(order.id, query).then((value) {
        _parseValue(null, order);
        print('initState ${order.toJson().toString()}');
        if (order.customer != null) {
          print('initState customer ${order.customer.toJson().toString()}');
          setState(() {
            _customer_lead_join = _getValue(order.customer.id);
          });
          if (_customer_lead_join == null) {
            _customer_lead_joins.add(CustomerLeadJoin(
                order.customer.id, null, order.customer.name, order.customer,
                null));
            _parseValue(_customer_lead_joins.last, null);
          } else {
            _parseValue(_customer_lead_join, null);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              DropdownSearch<CustomerLeadJoin>(
                autoFocusSearchBox: true,
                mode: Mode.MENU,
                selectedItem: _customer_lead_join,
                label: S.of(context).contact,
                onFind: (String filter) async {
                  _customer_leads = await _parseCustomerLead(filter);
                  _customers = await _parseCustomer(filter);

                  for(CustomerLead cl in _customer_leads){
                    _customer_lead_joins.add(CustomerLeadJoin(null, cl.id, cl.name, null, cl));
                  }

                  for(Customer c in _customers){
                    _customer_lead_joins.add(CustomerLeadJoin(c.id, null, c.name, c, null));
                  }
                  print('onFind ${filter} ${_customer_lead_joins.length}');
                  return _customer_lead_joins;
                },
                itemAsString: (CustomerLeadJoin u) {
                  return u.name;
                },
                onChanged: (CustomerLeadJoin data) {
                  setState(() {
                    _customer_lead_join = data;
                    _parseValue(data, null);
                  });
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textFullName,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).fullName,
                  border: OutlineInputBorder(),
                  suffixIcon: ElevatedButton(
                    onPressed: () async {
                      _contact = await FlutterContactPicker.pickPhoneContact();
                      textFullName.text = _contact.fullName;
                      String number = _contact.phoneNumber.number.replaceAll(regExp, '');
                      parseHandphone(number);
                    },
                    child: Icon(Icons.contacts),
                  ),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty) return S.of(context).fullNameIsRequired;
                  return null;
                },
              ),
              SizedBox(height: 10),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(S.of(context).gender),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Radio(value: 'm', groupValue: _gender, onChanged: (value){
                              setState(() {
                                _gender = value;
                              });
                            }),
                            Text(S.of(context).male),
                          ],
                        ),
                        Row(
                          children: [
                            Radio(value: 'f', groupValue: _gender, onChanged: (value){
                              setState(() {
                                _gender = value;
                              });
                            }),
                            Text(S.of(context).female),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textNik,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).idNumber,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // if (value.isEmpty) return 'Dp Harus Diisi';
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textNpwp,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).taxNumber,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  // if (value.isEmpty) return 'Dp Harus Diisi';
                  return null;
                },
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: CountryCodePicker(
                      onChanged: (value){
                        setState(() {
                          handphoneCountryCode = value.code;
                        });
                      },
                      initialSelection: handphoneCountryCode,
                      favorite: ['+62','ID'],
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: true,
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: TextFormField(
                      controller: textHandphone,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).handphone,
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value.isEmpty && textEmail.text.isEmpty) return S.of(context).handphoneIsRequired;
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textEmail,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).email,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  // if (value.isEmpty) return 'Email Harus Diisi';
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textAlamatLengkap,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).address,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textAlamatDomisili,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).addressCorrespondent,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          this.parent.onMenuClicked('payment_schema');
                        },
                        child: Text(S.of(context).back),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _prosesAction();
                        },
                        child: Text(S.of(context).process),
                      ),
                    ],
                  ),
                  loading ? LinearProgressIndicator() : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Customer>> _parseCustomer(search) async {
    Map<String, String> map = new Map();
    map.putIfAbsent("marketing_id", () => user.id.toString());
    map.putIfAbsent("limit", () => '10');
    if (search.length > 0) map.putIfAbsent("search", () => search);

    return await CustomerRest().getCustomers(map);
  }

  Future<List<CustomerLead>> _parseCustomerLead(search) async {
    Map<String, String> map = new Map();
    map.putIfAbsent("marketing_id", () => user.id.toString());
    map.putIfAbsent("limit", () => '10');
    if (search.length > 0) map.putIfAbsent("search", () => search);

    return await CustomerLeadRest().getCustomerLeads(map);
  }

  void _prosesAction() {
    if (_formKey.currentState.validate() && !loading) {
      setState(() {
        loading = true;
      });
      Map<String, String> map = new Map();
      map.putIfAbsent("name", () => textFullName.text);
      map.putIfAbsent("nik", () => textNik.text);
      map.putIfAbsent("npwp", () => textNpwp.text);
      if (textHandphone != null) map.putIfAbsent("handphone", () => '$handphoneDialCode${textHandphone.text}');
      map.putIfAbsent("address", () => textAlamatLengkap.text);
      map.putIfAbsent("address_correspondent", () => textAlamatDomisili.text);
      map.putIfAbsent("email", () => textEmail.text);
      map.putIfAbsent("gender", () => _gender);
      if (_customer_lead_join != null){
        if (_customer_lead_join.customer_id != null && _customer_lead_join.customer_id > 0){
          map.putIfAbsent("customer_id", () => _customer_lead_join.customer_id.toString());
        } else if(_customer_lead_join.customer_lead_id != null && _customer_lead_join.customer_lead_id > 0){
          map.putIfAbsent("customer_lead_id", () => _customer_lead_join.customer_lead_id.toString());
        }
      }
      if (user != null){
        map.putIfAbsent("marketing_id", () => user.id.toString());
      }

      OrderRest().identity(order.id, map).then((value) {
        if (value != null){
          setState(() {
            this.parent.order = value;
            loading = false;
          });
          print('OrderRest identity ${value.toString()}');

          this.parent.onMenuClicked('scan_document');
        }
      }).catchError((catchError){
        setState(() {
          loading = false;
        });

        var snackBar = SnackBar(content: Text('Gagal Input Data!'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
  }

  CustomerLeadJoin _getValue(customer_id){
    for (CustomerLeadJoin clj in _customer_lead_joins){
      if (clj.customer_id == order.customer.id) return clj;
    }
    return null;
  }

  _parseValue(CustomerLeadJoin clj, Order order){
    setState(() {
      if (order != null){
        textFullName.text = order.name;
        textNik.text = order.nik;
        textNpwp.text = order.npwp;
        // textHandphone.text = order.handphone;
        textEmail.text = order.email;
        textAlamatLengkap.text = order.address;
        textAlamatDomisili.text = order.address_correspondent;
        parseHandphone(order.handphone);
      } else if (clj != null){
        if (clj.customer_lead != null){
          _customer_lead = clj.customer_lead;
          textFullName.text = _customer_lead.name;
          textNik.text = _customer_lead.nik;
          textNpwp.text = _customer_lead.npwp;
          textHandphone.text = _customer_lead.handphone;
          textEmail.text = _customer_lead.email;
          textAlamatLengkap.text = _customer_lead.address;
          textAlamatDomisili.text = _customer_lead.address_correspondent;
          parseHandphone(_customer_lead.handphone);
        } else if (clj.customer != null){
          _customer = clj.customer;
          textFullName.text = _customer.name;
          textNik.text = _customer.nik;
          textNpwp.text = _customer.npwp;
          // textHandphone.text = _customer.handphone;
          textEmail.text = _customer.email;
          textAlamatLengkap.text = _customer.address;
          textAlamatDomisili.text = _customer.address_correspondent;

          parseHandphone(_customer.handphone);
        }
      }
    });
  }

  String parseHandphone(String number){
    Map<String, String> map = Helpers().parseCountries(number);
    if (map != null && map.length > 0 && number != null){
      setState(() {
        String code = map['code'];
        String dial_code = map['dial_code'];
        handphoneValue = number;
        handphoneCountryCode = code;
        handphoneDialCode = dial_code.replaceAll(regExp, '');

        String numberOnly = number.replaceFirst(handphoneDialCode, '');
        numberOnly = numberOnly.replaceFirst('0', '');
        textHandphone.text = numberOnly;
      });
    }
  }
}
