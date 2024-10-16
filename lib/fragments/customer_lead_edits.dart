import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import '../generated/l10n.dart';
import '../constants.dart';
import '../utils/currency_input_formatter.dart';
import '../utils/helpers.dart';
import '../rests/customer_lead_detail_rest.dart';
import '../rests/event_rest.dart';
import '../rests/customer_rest.dart';
import '../rests/customer_lead_rest.dart';
import '../entities/activity.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_unit.dart';
import '../entities/customer.dart';
import '../entities/customer_lead_detail.dart';
import '../entities/customer_lead.dart';
import '../entities/event.dart';
import '../entities/user.dart';
import '../entities/object.dart';
import '../rests/activity_rest.dart';
import '../menu.dart';

class CustomerLeadEdits extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  CustomerLeadEdits(this.parent);

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
  Customer _customer;
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
  List<Object> _klasifikasi_list = [];
  List<Object> _response_list = [];
  List<Object> _type_list = [];
  var _gender = 'm';
  String handphoneValue = '';
  String handphoneCountryCode = 'ID';
  String handphoneDialCode = '62';
  PhoneContact _contact;
  var regExp = RegExp(r'[^0-9]');
  bool loading = false;
  bool _contact_added = false;
  final _formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<Activity>> _dropdownActivity = [];
  List<DropdownMenuItem<Event>> _dropdownEvent = [];
  List<DropdownMenuItem<Object>> _dropdownKlasifikasi = [];
  List<DropdownMenuItem<Object>> _dropdownResponse = [];
  List<DropdownMenuItem<Object>> _dropdownType = [];

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
    _customer = this.parent.customer;
    _customer_lead = this.parent.customer_lead;

    if (_customer != null){
      textFullName.text = _customer.name;
      textBirthDate.text = _customer.birth_date;
      textNik.text = _customer.nik;
      textNpwp.text = _customer.npwp;
      // textHandphone.text = _customer.handphone;
      textEmail.text = _customer.email;
      textAlamatLengkap.text = _customer.address;
      textAlamatDomisili.text = _customer.address_correspondent;
      parseHandphone(_customer.handphone);

      _getApartment(_customer, null);

      setState(() {
        this.parent.selectedTitle = Constants.customer_edit ?? Constants.appName;
        this.parent.appBarTitle = Text(Constants.customer_edit ?? Constants.appName);
      });
    } else if (_customer_lead != null){
      textFullName.text = _customer_lead.name;
      textBirthDate.text = _customer_lead.birth_date;
      textNik.text = _customer_lead.nik;
      textNpwp.text = _customer_lead.npwp;
      // textHandphone.text = _customer_lead.handphone;
      textEmail.text = _customer_lead.email;
      textAlamatLengkap.text = _customer_lead.address;
      textAlamatDomisili.text = _customer_lead.address_correspondent;
      parseHandphone(_customer_lead.handphone);

      setState(() {
        this.parent.appBarTitle = Text(Constants.customer_lead_edit ?? Constants.appName);
        _klasifikasi_list = _getKlasifikasiList();
        _dropdownKlasifikasi = [];
        for (Object object in _klasifikasi_list) {
          _dropdownKlasifikasi.add(
            DropdownMenuItem(
              child: Text(object.value),
              value: object,
            ),
          );
        }

        _response_list = _getResponseList();
        _dropdownResponse = [];
        for (Object object in _response_list) {
          _dropdownResponse.add(
            DropdownMenuItem(
              child: Text(object.value),
              value: object,
            ),
          );
        }

        _type_list = _getTypeList();
        _dropdownType = [];
        for (Object object in _type_list) {
          _dropdownType.add(
            DropdownMenuItem(
              child: Text(object.value),
              value: object,
            ),
          );
        }
      });

      _getApartment(null, _customer_lead);
      Map<String, String> query = Map();
      query.putIfAbsent('customer_lead_id', () => _customer_lead.id.toString());

      CustomerLeadDetailRest().last(query).then((value) {
        if (value != null){
          setState(() {
            _customer_lead_detail = value;

            textInformation.text = _customer_lead_detail.description;
            textBuyDate.text = _customer_lead_detail.buy_date;
            textProduct.text = _customer_lead_detail.product;
            textPrice.text = Helpers.currency(_customer_lead_detail.price);
            textUnit.text = _customer_lead_detail.unit;

            _klasifikasi = _getKlasifikasi(_customer_lead_detail.classification);
            _response = _getResponse(_customer_lead_detail.response);
            _type = _getType(_customer_lead_detail.type);
            // _klasifikasi = 'Brazil';
            print('_klasifikasi $_klasifikasi');
          });
        }
      });
    }

    Map<String, String> map = Map();
    ActivityRest().getActivities(map).then((value) {
      if (_customer_lead.activity_id != null){
        for(Activity activity in value){
          if (activity.id == _customer_lead.activity_id){
            setState(() {
              _activity = activity;
            });
            print('_activity ${activity.toJson().toString()}');
          }
        }
      }

      setState(() {
        _activities = value;
        
        for (Activity activity in _activities) {
          _dropdownActivity.add(
            DropdownMenuItem(
              child: Text(activity.name),
              value: activity,
            ),
          );
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.all(4),
      child: Padding(
        padding: EdgeInsets.all(4),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.zero,
                  child: ExpansionCard(
                    margin: EdgeInsets.zero,
                    initiallyExpanded: true,
                    title: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            S.of(context).contactEdit,
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
                        mode: Mode.MENU,
                        selectedItem: _apartment,
                        label: S.of(context).apartment,
                        items: this.parent.listApartment,
                        onFind: (String filter) async {
                          return [];
                        },
                        itemAsString: (Apartment u) {
                          return u.name;
                        },
                        onChanged: (Apartment data) {
                          setState(() {
                            _apartment = data;
                          });
                          _getEvents(data);
                        },
                        validator: (Apartment data){
                          if (data == null) return S.of(context).apartmentIsRequired;
                          return null;
                        },
                      ),
                      _customer_lead != null ? SizedBox(height: 10) : Container(),
                      _customer_lead != null ? DropdownButtonFormField<Activity>(
                        items: _dropdownActivity,
                        value: _activity,
                        isExpanded: true,

                        decoration: InputDecoration(
                          labelText: S.of(context).activity,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (Activity Value) {
                          setState(() {
                            _activity = Value;
                          });
                        },
                        validator: (Activity data){
                          if (data == null) return S.of(context).activityIsRequired;
                          return null;
                        },
                      ) : Container(),
                      _customer_lead != null ? SizedBox(height: 10) : Container(),
                      _customer_lead != null ? DropdownButtonFormField<Event>(
                        items: _dropdownEvent,
                        value: _event,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).event,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (Event data) {
                          setState(() {
                            _event = data;
                          });
                        },
                        validator: (Event data){
                          if (data == null) return S.of(context).eventIsRequired;
                          return null;
                        },
                      ) : Container(),
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
                        validator: (value) {
                          if (value.isEmpty && textHandphone.text.isEmpty) return S.of(context).emailIsRequired;
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
                SizedBox(height: 10),
                _customer_lead != null ? Card(
                  margin: EdgeInsets.zero,
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
                      _dropdownKlasifikasi.length > 0 ? SizedBox(height: 10) : Container(),
                      _dropdownKlasifikasi.length > 0 ? DropdownButtonFormField<Object>(
                        items: _dropdownKlasifikasi,
                        value: _klasifikasi,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).classification,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (Object data) {
                          setState(() {
                            _klasifikasi = data;
                          });
                        },
                        validator: (Object data){
                          if (data == null) return S.of(context).classificationIsRequired;
                          return null;
                        },
                      ) : Container(),
                      _dropdownResponse.length > 0 ? SizedBox(height: 10) : Container(),
                      _dropdownResponse.length > 0 ? DropdownButtonFormField<Object>(
                        items: _dropdownResponse,
                        value: _response,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: S.of(context).customerResponse,
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (Object data) {
                          setState(() {
                            _response = data;
                          });
                        },
                        validator: (Object data){
                          if (data == null) return S.of(context).customerResponseIsRequired;
                          return null;
                        },
                      ) : Container(),
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
                      // _dropdownType.length > 0 ? SizedBox(height: 10) : Container(),
                      // _dropdownType.length > 0 ? DropdownButtonFormField<Object>(
                      //   items: _dropdownType,
                      //   value: _type,
                      //   isExpanded: true,
                      //   decoration: InputDecoration(
                      //     labelText: 'Tipe Produk',
                      //     border: OutlineInputBorder(),
                      //   ),
                      //   onChanged: (Object data) {
                      //     setState(() {
                      //       _type = data;
                      //     });
                      //   },
                      // ) : Container(),
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
                ) : Container(),
                SizedBox(height: 10),
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
                              if (!loading) _prosesAction(context);
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
      ),
    );
  }

  void _prosesAction(BuildContext context) {
    if (textFullName.text.isEmpty || (textHandphone.text.isEmpty && textEmail.text.isEmpty)){
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
    if (user != null) map.putIfAbsent("marketing_id", () => user.id.toString());
    if (textBirthDate != null) map.putIfAbsent("birth_date", () => textBirthDate.text);
    if (_apartment != null && _apartment.id > 0) map.putIfAbsent("apartment_id", () => _apartment.id.toString());
    if (_event != null && _event.id > 0) map.putIfAbsent("event_id", () => _event.id.toString());
    if (_activity != null && _activity.id > 0) map.putIfAbsent("activity_id", () => _activity.id.toString());

    if (_customer_lead != null) {
      CustomerLeadRest().update(_customer_lead.id, map).then((value) {
        if (value != null){
          setState(() {
            this.parent.customer_lead = value;
          });
          // this.parent.onMenuClicked('customer');

          Map<String, String> mapDetail = new Map();
          mapDetail.putIfAbsent("customer_lead_id", () => value.id.toString());
          if (_klasifikasi != null) mapDetail.putIfAbsent("classification", () => _klasifikasi.key);
          if (_response != null) mapDetail.putIfAbsent("response", () => _response.key);
          if (_type != null) mapDetail.putIfAbsent("type", () => _type.key);
          mapDetail.putIfAbsent("description", () => textInformation.text);
          mapDetail.putIfAbsent("product", () => textProduct.text);
          if (textPrice != null){
            double price = Helpers.toDouble(textPrice.text.replaceAll('.', ''));
            mapDetail.putIfAbsent("price", () => price.toString());
          }
          mapDetail.putIfAbsent("unit", () => textUnit.text);
          mapDetail.putIfAbsent("buy_date", () => textBuyDate.text);
          CustomerLeadDetailRest().add(mapDetail).then((value) {
            setState(() {
              loading = false;
            });
            if (value != null){
              _customer_lead_detail = value;
            }
            this.parent.onMenuClicked('customer');
          }).catchError((catchError){
            setState(() {
              loading = false;
            });

            print('catchError add ${catchError.toString()}');

            var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        } else {
          setState(() {
            loading = false;
          });
        }
      }).catchError((catchError){
        setState(() {
          loading = false;
        });

        print('catchError update ${catchError.toString()}');

        var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    } else if (_customer != null) {
      CustomerRest().update(_customer.id, map).then((value) {
        if (value != null){
          setState(() {
            this.parent.customer = value;
          });
        }
        this.parent.onMenuClicked('customer');
      }).catchError((catchError){
        setState(() {
          loading = false;
        });

        print('catchError ${catchError.toString()}');

        var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }
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

          _dropdownEvent = [];
          for(Event event in _events){
            if (_customer_lead != null && event.id == _customer_lead.event_id){
              _event = event;
            }

            _dropdownEvent.add(
              DropdownMenuItem(
                child: Text(event.name),
                value: event,
              ),
            );
          }
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

  List<Object> _getKlasifikasiList() {
    List<Object> list = [];
    list.add(Object('unknown', 'Unknown'));
    list.add(Object('leads', 'Leads'));
    list.add(Object('prospect', 'Prospect'));
    list.add(Object('hot_prospect', 'Hot Prospect'));
    list.add(Object('customer', 'Customer'));
    list.add(Object('cancel', 'Cancel'));
    return list;
  }

  List<Object> _getResponseList() {
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

  List<Object> _getTypeList() {
    List<Object> list = [];
    list.add(Object('residential', 'Residential'));
    list.add(Object('commercial', 'Commercial'));
    list.add(Object('hospitality', 'Hospitality'));
    return list;
  }

  Object _getKlasifikasi(String code) {
    Object result;
    for(Object obj in _klasifikasi_list){
      if (result == null) result = obj;
      if (code == obj.key) {
        return obj;
      }
    }
    return result;
  }

  Object _getResponse(String code) {
    Object result;
    for(Object obj in _response_list){
      if (result == null) result = obj;
      if (code == obj.key) return obj;
    }
    return result;
  }

  Object _getType(String code) {
    Object result;
    for(Object obj in _type_list){
      if (result == null) result = obj;
      if (code == obj.key) return obj;
    }
    return result;
  }

  _getApartment(Customer customer, CustomerLead customer_lead){
    if (this.parent.listApartment != null && mounted){
      setState(() {
        if (this.parent.listApartment.length == 1){
          _apartment = this.parent.listApartment.first;
          _getEvents(_apartment);
        } else if (customer != null){
          for(Apartment ap in this.parent.listApartment){
            if (customer.apartment_id == ap.id) {
              _apartment = ap;
              _getEvents(_apartment);
              break;
            }
          }
        } else if (customer_lead != null){
          for(Apartment ap in this.parent.listApartment){
            if (customer_lead.apartment_id == ap.id) {
              _apartment = ap;
              _getEvents(_apartment);
              break;
            }
          }
        }
      });
    }
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
