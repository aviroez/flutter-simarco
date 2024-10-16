import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:simarco/generated/l10n.dart';
import '../entities/customer_lead_detail.dart';
import '../rests/customer_lead_detail_rest.dart';
import '../utils/currency_input_formatter.dart';
import '../utils/helpers.dart';
import '../entities/activity.dart';
import '../entities/customer_lead_join.dart';
import '../entities/event.dart';
import '../rests/activity_rest.dart';
import '../rests/event_rest.dart';
import '../entities/customer_lead.dart';
import '../rests/customer_lead_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_unit.dart';
import '../entities/user.dart';
import '../entities/object.dart';
import '../menu.dart';

class CustomerLeadAdds extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  CustomerLeadAdds(this.parent);

  @override
  Widget build(BuildContext context) {
    return PaymentSchemaStatefulWidget(this.parent);
  }
}
class PaymentSchemaStatefulWidget extends StatefulWidget {
  CustomMenuStatefulWidget parent;
  PaymentSchemaStatefulWidget(this.parent);

  @override
  _PaymentSchemaStatefulWidget createState() => _PaymentSchemaStatefulWidget(this.parent);
}

class _PaymentSchemaStatefulWidget extends State<PaymentSchemaStatefulWidget> {
  User user;
  Apartment _apartment;
  ApartmentTower apartment_tower;
  ApartmentUnit apartment_unit;
  CustomerLead _customer_lead;
  CustomerLeadDetail _customer_lead_detail;
  Object _klasifikasi;
  Object _response;
  Object _type;
  Activity _activity;
  Event _event;
  CustomMenuStatefulWidget parent;
  List<Apartment> _apartments = [];
  List<Event> _events = [];
  List<Activity> _activities = [];
  List<CustomerLead> _customer_leads = [];
  List<CustomerLeadJoin> _customer_lead_joins = [];
  var _gender = 'm';
  String handphoneValue = '';
  String handphoneCountryCode = 'ID';
  String handphoneDialCode = '62';
  PhoneContact _contact;
  var _phoneNumber;
  bool loading = false;
  bool _contact_added = false;
  final _formKey = GlobalKey<FormState>();

  _PaymentSchemaStatefulWidget(this.parent);

  TextEditingController textFullName = TextEditingController();
  TextEditingController textBirthDate = TextEditingController();
  TextEditingController textNik = TextEditingController();
  TextEditingController textNpwp = TextEditingController();
  TextEditingController textHandphone = TextEditingController();
  TextEditingController textEmail = TextEditingController();
  TextEditingController textAlamatLengkap = TextEditingController();
  TextEditingController textAlamatDomisili = TextEditingController();
  TextEditingController textInformation = TextEditingController();
  TextEditingController textBuyDate = TextEditingController();
  TextEditingController textProduct = TextEditingController();
  TextEditingController textPrice = TextEditingController();
  TextEditingController textUnit = TextEditingController();

  @override
  void initState() {
    super.initState();

    user = this.parent.user;

    Map<String, String> map = Map();
    ActivityRest().getActivities(map).then((value) {
      setState(() {
        _activities = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(4),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: ExpansionCard(
                  margin: EdgeInsets.zero,
                  initiallyExpanded: true,
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).contactAdd,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    DropdownSearch<Apartment>(
                      autoFocusSearchBox: true,
                      selectedItem: _apartment,
                      label: S.of(context).apartment,
                      onFind: (String filter) async {
                        return this.parent.listApartment;
                      },
                      itemAsString: (Apartment u) {
                        return u.name;
                      },
                      onChanged: (Apartment data) {
                        setState(() {
                          _apartment = data;
                          _getEvents(data);
                        });
                      },
                      validator: (Apartment data){
                        if (data == null) return S.of(context).apartmentIsRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<Activity>(
                      autoFocusSearchBox: true,
                      selectedItem: _activity,
                      label: S.of(context).activity,
                      onFind: (String filter) async {
                        return _activities;
                      },
                      itemAsString: (Activity u) {
                        return u.name;
                      },
                      onChanged: (Activity data) {
                        setState(() {
                          _activity = data;
                        });
                      },
                      validator: (Activity data){
                        if (data == null) return S.of(context).activityIsRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<Event>(
                      autoFocusSearchBox: true,
                      selectedItem: _event,
                      label: S.of(context).event,
                      onFind: (String filter) async {
                        return _events;
                      },
                      itemAsString: (Event u) {
                        if (u.start_date != null && u.end_date != null) return '${u.name} (${u.start_date} - ${u.end_date})';
                        if (u.start_date != null) return '${u.name} (${u.start_date})';
                        if (u.end_date != null) return '${u.name} (${u.end_date})';
                        return u.name;
                      },
                      onChanged: (Event data) {
                        setState(() {
                          _event = data;
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
                            var regExp = RegExp(r'[^0-9]');
                            textFullName.text = _contact.fullName;
                            String number = _contact.phoneNumber.number.replaceAll(regExp, '');
                            Map<String, String> map = Helpers().parseCountries(number);
                            if (map != null && map.length > 0 && _contact.phoneNumber != null && _contact.phoneNumber.number.length > 0){
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
                          },
                          child: Icon(Icons.contacts),
                        ),
                      ),
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if (value.isEmpty && _contact_added) return S.of(context).fullNameIsRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      onTap: () async {
                        _birthDatePicker(context);
                      },
                      controller: textBirthDate,
                      initialValue: null,
                      decoration: InputDecoration(
                          labelText: S.of(context).birthDate,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note)
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(S.of(context).gender),
                          Row(
                            children: [
                              Radio(value: 'm', groupValue: _gender, onChanged: (value){
                                setState(() {
                                  _gender = value;
                                });
                              }),
                              Text(S.of(context).male),
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
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textNik,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).idNumber,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textNpwp,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).taxNumber,
                        border: OutlineInputBorder(),
                      ),
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
                              if (value.isEmpty) return S.of(context).handphoneIsRequired;
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
                      validator: (value) {
                        if (value.isEmpty) return S.of(context).emailIsRequired;
                        else if (value.isNotEmpty && !Helpers.isEmail(value)) return S.of(context).emailIsInvalid;
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
                  ],
                ),
              ),
              Card(
                child: ExpansionCard(
                  margin: EdgeInsets.zero,
                  initiallyExpanded: true,
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).activityResult,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    DropdownSearch<Object>(
                      autoFocusSearchBox: true,
                      selectedItem: _klasifikasi,
                      label: S.of(context).classification,
                      onFind: (String filter) async {
                        return _getKlasifikasi();
                      },
                      itemAsString: (Object u) {
                        return u.value;
                      },
                      onChanged: (Object data) {
                        setState(() {
                          _klasifikasi = data;
                        });
                      },
                      validator: (Object data) {
                        if (data == null) return S.of(context).classificationIsRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<Object>(
                      autoFocusSearchBox: true,
                      selectedItem: _response,
                      label: S.of(context).customerResponse,
                      onFind: (String filter) async {
                        return _getResponse();
                      },
                      itemAsString: (Object u) {
                        return u.value;
                      },
                      onChanged: (Object data) {
                        setState(() {
                          _response = data;
                        });
                      },
                      validator: (Object data) {
                        if (data == null) return S.of(context).customerResponseIsRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textInformation,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).information,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      onTap: () async {
                        _buyDatePicker(context);
                      },
                      controller: textBuyDate,
                      initialValue: null,
                      decoration: InputDecoration(
                          labelText: S.of(context).purchaseDate,
                          border: OutlineInputBorder(),
                          suffixIcon: Icon(Icons.event_note)
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<Object>(
                      autoFocusSearchBox: true,
                      selectedItem: _type,
                      label: S.of(context).productType,
                      onFind: (String filter) async {
                        return _getType();
                      },
                      itemAsString: (Object u) {
                        return u.value;
                      },
                      onChanged: (Object data) {
                        setState(() {
                          _type = data;
                        });
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textProduct,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).product,
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textPrice,
                      initialValue: null,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: S.of(context).price,
                        border: OutlineInputBorder(),
                        prefixText: S.of(context).currencyLocale,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textUnit,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).unit,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          this.parent.onMenuClicked('customer');
                        },
                        child: Text(S.of(context).back),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            if (!loading) {
                              _prosesAction(context);
                            }
                          }
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

  void _prosesAction(BuildContext context) {
    if (textFullName.text.isEmpty || ((_phoneNumber == null || _phoneNumber.completeNumber == null) && textEmail.text.isEmpty)){
      var snackBar = SnackBar(content: Text(S.of(context).fillAllData));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }
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
    if (_customer_lead != null) map.putIfAbsent("id", () => _customer_lead.id.toString());
    if (user != null) map.putIfAbsent("marketing_id", () => user.id.toString());
    if (textBirthDate != null) map.putIfAbsent("birth_date", () => textBirthDate.text);
    if (_apartment != null && _apartment.id > 0) map.putIfAbsent("apartment_id", () => _apartment.id.toString());
    if (_event != null && _event.id > 0) map.putIfAbsent("event_id", () => _event.id.toString());
    if (_activity != null && _activity.id > 0) map.putIfAbsent("activity_id", () => _activity.id.toString());

    CustomerLeadRest().add(map).then((value) {
      if (value != null) {
        setState(() {
          this.parent.customer_lead = value;
        });

        Map<String, String> mapDetail = new Map();
        mapDetail.putIfAbsent("customer_lead_id", () => value.id.toString());
        if (_klasifikasi != null) mapDetail.putIfAbsent("classification", () => _klasifikasi.value);
        if (_response != null) mapDetail.putIfAbsent("response", () => _response.value);
        if (_type != null) mapDetail.putIfAbsent("type", () => _type.value);
        mapDetail.putIfAbsent("description", () => textInformation.text);
        mapDetail.putIfAbsent("product", () => textProduct.text);
        mapDetail.putIfAbsent("price", () => textPrice.text);
        mapDetail.putIfAbsent("unit", () => textUnit.text);
        mapDetail.putIfAbsent("buy_date", () => textBuyDate.text);
        CustomerLeadDetailRest().add(mapDetail).then((value) {
          if (value != null){
            _customer_lead_detail = value;
          }
          setState(() {
            loading = false;
          });
          this.parent.onMenuClicked('customer');
        }).catchError((catchError){
          setState(() {
            loading = false;
          });

          var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        setState(() {
          loading = true;
        });
        var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }).catchError((catchError){
      setState(() {
        loading = false;
      });

      var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  _getEvents(Apartment apartment){
    if (apartment != null){
      Map<String, String> map = Map();
      map.putIfAbsent("order_by_desc[0]", () => "start_date");
      map.putIfAbsent("order_by_desc[1]", () => "end_date");
      map.putIfAbsent("active", () => "1");
      map.putIfAbsent("apartment_id", () => apartment.id.toString());
      EventRest().getEvents(map).then((value) {
        setState(() {
          _events = value;
          _event = null;
        });
      });
    } else {
      setState(() {
        _events = [];
        _event = null;
      });
    }
  }

  Future<Null> _birthDatePicker(BuildContext context) async {
    int y = DateTime.now().year - 17;
    int m = 1;
    int d = 1;
    if (textBirthDate != null && textBirthDate.text != null && textBirthDate.text.length > 0){
      var currentDate = textBirthDate.text.split('-');
      y = Helpers.toInt(currentDate[0]);
      m = Helpers.toInt(currentDate[1]);
      d = Helpers.toInt(currentDate[2]);
    }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(y, m, d),
      firstDate: DateTime(DateTime.now().year - 100, 1),
      lastDate: DateTime.now(),
    );

    if (picked != null){
      setState(() {
        // _startDate = picked;
        textBirthDate.value = TextEditingValue(text: picked.toString().replaceAll(' 00:00:00.000', ''));
      });
    }
  }

  Future<Null> _buyDatePicker(BuildContext context) async {
    int y = DateTime.now().year;
    int m = DateTime.now().month;
    int d = DateTime.now().day;
    if (textBuyDate != null && textBuyDate.text != null && textBuyDate.text.length > 0){
      var currentDate = textBuyDate.text.split('-');
      y = Helpers.toInt(currentDate[0]);
      m = Helpers.toInt(currentDate[1]);
      d = Helpers.toInt(currentDate[2]);
    }
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime(y, m, d),
      firstDate: DateTime(DateTime.now().year - 10, 1),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if(picked != null){
      setState(() {
        // _buyDate = picked;
        textBuyDate.value = TextEditingValue(text: picked.toString().replaceAll(' 00:00:00.000', ''));
      });
    }
  }

  List<Object> _getKlasifikasi() {
    List<Object> list = [];
    list.add(Object('unknown', 'Unknown'));
    list.add(Object('leads', 'Leads'));
    list.add(Object('prospect', 'Prospect'));
    list.add(Object('hot_prospect', 'Hot Prospect'));
    list.add(Object('customer', 'Customer'));
    list.add(Object('cancel', 'Cancel'));
    return list;
  }

  List<Object> _getResponse() {
    List<Object> list = [];
    list.add(Object('unknown', 'Unknown'));
    list.add(Object('answer_waiting', 'Answer Waiting'));
    list.add(Object('visit_mo', 'Visit Mo'));
    list.add(Object('deal_processing', 'Deal Processing'));
    list.add(Object('deal_success', 'Deal Success'));
    list.add(Object('not_interested', 'Not Interested'));
    list.add(Object('invalid_number', 'Invalid Number'));
    list.add(Object('complain', 'Complain'));
    list.add(Object('no_respond', 'No Respond'));
    return list;
  }

  List<Object> _getType() {
    List<Object> list = [];
    list.add(Object('residential', 'Residential'));
    list.add(Object('commercial', 'Commercial'));
    list.add(Object('hospitality', 'Hospitality'));
    return list;
  }
}
