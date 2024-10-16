import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expansion_card/expansion_card.dart';
import 'package:geolocator/geolocator.dart';
import 'package:android_intent/android_intent.dart';
import '../generated/l10n.dart';
import '../utils/helpers.dart';
import '../entities/customer_lead_detail.dart';
import '../entities/event_activity_log.dart';
import '../rests/customer_lead_detail_rest.dart';
import '../rests/event_activity_log_rest.dart';
import '../rests/image_rest.dart';
import '../entities/activity.dart';
import '../entities/event.dart';
import '../rests/activity_rest.dart';
import '../entities/customer_lead.dart';
import '../rests/customer_lead_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_unit.dart';
import '../entities/user.dart';
import '../entities/object.dart';
import '../menu.dart';

class EventDetailAdds extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  EventDetailAdds(this.parent);

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

class _PaymentSchemaStatefulWidget extends State<PaymentSchemaStatefulWidget> with WidgetsBindingObserver {
  User user;
  ApartmentTower apartment_tower;
  ApartmentUnit apartment_unit;
  CustomerLeadDetail _customer_lead_detail;
  EventActivityLog eventActivityLog;
  Event event;
  Object _klasifikasi;
  Object _response;
  Object _type;
  Activity _activity;
  CustomMenuStatefulWidget parent;
  List<Activity> _activities = [];
  var _gender = 'm';
  String _location;
  File _file;
  bool _contact_added = false;
  bool _classification_added = false;
  bool isGpsEnabled = false;
  Position _position;
  // Address _address;
  Placemark _address;
  PhoneContact _contact;

  _PaymentSchemaStatefulWidget(this.parent);

  final _formKey = GlobalKey<FormState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

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

    WidgetsBinding.instance.addObserver(this);

    event = this.parent.event;
    user = this.parent.user;

    Map<String, String> map = Map();
    ActivityRest().getActivities(map).then((value) {
      setState(() {
        _activities = value;
      });
    });

    _checkGps();

    // _determinePosition().then((value) {
    //   if (value != null){
    //     _position = value;
    //     print('position ${_position.latitude},${_position.longitude}');
    //
    //      _getLocationName(_position).then((value) {
    //       if (value != null){
    //         _address = value;
    //       }
    //     });
    //   }
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      _checkGps();
    } else if(state == AppLifecycleState.inactive){
      // app is inactive
    } else if(state == AppLifecycleState.paused){
      // user is about quit our app temporally
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      // padding: EdgeInsets.only(left: 4, right: 4),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Text(S.of(context).eventLabel),
                          ),
                          Text(event != null ? event.name : ''),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(S.of(context).apartmentLabel),
                          ),
                          Text(event != null && event.apartment != null ? event.apartment.name : ''),
                        ],
                      ),
                      SizedBox(height: 10),
                      DropdownSearch<Activity>(
                        mode: Mode.MENU,
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
                        validator: (Activity data) {
                          if (data == null) return S.of(context).activityIsRequired;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: ExpansionCard(
                  margin: EdgeInsets.all(0),
                  initiallyExpanded: false,
                  onExpansionChanged: (value) {
                    setState(() {
                      _contact_added = value;
                    });
                  },
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
                            textHandphone.text = _contact.phoneNumber.number;
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
                    AbsorbPointer(
                      child: TextFormField(
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
                    TextFormField(
                      controller: textHandphone,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: S.of(context).handphone,
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty && textEmail.text.isEmpty && _contact_added) return S.of(context).handphoneIsRequired;
                        return null;
                      },
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
                        if (value.isEmpty && textHandphone.text.isEmpty && _contact_added) return S.of(context).emailIsRequired;
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
                  margin: EdgeInsets.all(0),
                  initiallyExpanded: _contact_added,
                  onExpansionChanged: (value) {
                    setState(() {
                      _classification_added = value;
                    });
                  },
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
                      mode: Mode.MENU,
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
                      validator: (Object value) {
                        if (value == null && _contact_added) return S.of(context).classificationIsRequired;
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<Object>(
                      mode: Mode.MENU,
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
                      validator: (Object value) {
                        if (value == null && _contact_added) return S.of(context).customerResponseIsRequired;
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
                    AbsorbPointer(
                      child: TextFormField(
                        controller: textBuyDate,
                        initialValue: null,
                        decoration: InputDecoration(
                            labelText: S.of(context).purchaseDate,
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.event_note)
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    DropdownSearch<Object>(
                      mode: Mode.MENU,
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
                      validator: (Object value) {
                        if (value == null && _contact_added) return S.of(context).productTypeIsRequired;
                        return null;
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
                      decoration: InputDecoration(
                        labelText: S.of(context).price,
                        border: OutlineInputBorder(),
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
              Card(
                child: ExpansionCard(
                  margin: EdgeInsets.all(0),
                  initiallyExpanded: true,
                  title: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          S.of(context).imageResult,
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  children: [
                    Text(S.of(context).image),
                    _file != null ? Image.file(_file, height: 125) : Icon(Icons.picture_in_picture_alt, size: 125),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 4, right: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        this.parent.onMenuClicked('event_detail');
                      },
                      child: Text(S.of(context).back),
                    ),
                    Expanded(child: Container()),
                    ElevatedButton(
                      onPressed: () {
                        _imgFromCamera(context);
                      },
                      child: Text(S.of(context).capture),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _prosesAction(context);
                      },
                      child: Text(S.of(context).process),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _prosesAction(BuildContext context) {
    if (!_formKey.currentState.validate()) {
      return null;
    } else if (_file == null){
      final snackBar = SnackBar(
        content: Text(S.of(context).captureImageFirst),
        action: SnackBarAction(
          label: S.of(context).close,
          onPressed: () {

          },
        ),
      );
      // Scaffold.of(context).showSnackBar(snackBar);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return null;
    }
    Map<String, String> map = new Map();
    if (_position != null){
      map.putIfAbsent("latitude", () => _position.latitude.toString());
      map.putIfAbsent("longitude", () => _position.longitude.toString());
    }
    if (user != null) map.putIfAbsent("marketing_id", () => user.id.toString());
    if (event != null){
      map.putIfAbsent("event_id", () => event.id.toString());
      map.putIfAbsent("apartment_id", () => event.apartment_id.toString());
    }
    if (_activity != null) map.putIfAbsent("activity_id", () => _activity.id.toString());
    if (_address != null) map.putIfAbsent("location", () => '${_address.thoroughfare} ${_address.subThoroughfare}, ${_address.subLocality}, ${_address.subAdministrativeArea}, ${_address.administrativeArea}');
    else if (_location != null) map.putIfAbsent("location", () => _location);
    // if (eventActivityLog != null){ map.putIfAbsent("id", () => eventActivityLog.id.toString());
    // Call<ResponseEventActivityLog> callActivity = activityService.addEventActivityLog(map);
    EventActivityLogRest().add(map).then((value) {
      if (value != null){
        eventActivityLog = value;

        if (_file != null){
          _uploadFile(eventActivityLog, _file, 'selfie');
        } else {
          this.parent.onMenuClicked('event_detail');
        }
      }
    });
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

  _imgFromCamera(BuildContext context) async {
    try{
      PickedFile image = (await ImagePicker().getImage(
          source: ImageSource.camera, imageQuality: 50
      ));

      if (image != null){
        setState(() {
          _file = File(image.path);
        });
      }
    } on PlatformException catch (err) {
      var snackBar = SnackBar(content: Text(S.of(context).openCameraFailed),
          action: SnackBarAction(
            label: S.of(context).close,
            onPressed: () {
            },
          )
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (err) {

    }
  }

  _addCustomerLead(){
    Map<String, String> map = new Map();
    map.putIfAbsent("name", () => textFullName.text);
    map.putIfAbsent("nik", () => textNik.text);
    map.putIfAbsent("npwp", () => textNpwp.text);
    map.putIfAbsent("handphone", () => textHandphone.text);
    map.putIfAbsent("email", () => textEmail.text);
    map.putIfAbsent("address", () => textAlamatLengkap.text);
    if (textBirthDate != null) map.putIfAbsent("birth_date", () => textBirthDate.value.text);
    if (user != null) map.putIfAbsent("marketing_id", () => user.id.toString());
    map.putIfAbsent("event_activity_log_id", () => eventActivityLog.id.toString());
    if (_gender != null) map.putIfAbsent("gender", () => _gender);

    CustomerLeadRest().add(map).then((value) {
      if (value != null){
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
          this.parent.onMenuClicked('event_detail');
        });
      } else {
        this.parent.onMenuClicked('event_detail');
      }
    });
  }

  _uploadFile(EventActivityLog eventActivityLog, File file, String code) {
    Map<String, String> map = new Map();
    map.putIfAbsent('code[]', () => code);
    ImageRest().eventactivitylog(eventActivityLog.id, file, map, code).then((value) {
      if (value != null){

      }
      _addCustomerLead();
    });
  }

  // Future<Position> _determinePosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return Future.error('Location services are disabled.');
  //   }
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.deniedForever) {
  //     return Future.error(
  //         'Location permissions are permantly denied, we cannot request permissions.');
  //   }
  //
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission != LocationPermission.whileInUse &&
  //         permission != LocationPermission.always) {
  //       return Future.error(
  //           'Location permissions are denied (actual value: $permission).');
  //     }
  //   }
  //
  //   return await Geolocator.getCurrentPosition();
  // }

  // Future<Address> _getLocationName(Position position) async {
  //   final coordinates = new Coordinates(position.latitude, position.longitude);
  //   List<Address> addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   return addresses.first;
  // }

  Future _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      if (Theme.of(context).platform == TargetPlatform.android) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(S.of(context).myLocationIsNotActive),
              content: Text(S.of(context).activateMyLocationNow),
              actions: <Widget>[
                FlatButton(
                  child: Text(S.of(context).yes),
                  onPressed: () {
                    final AndroidIntent intent = AndroidIntent(
                        action: 'android.settings.LOCATION_SOURCE_SETTINGS'
                    );

                    intent.launch();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      _getCurrentLocation();
    }
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _position = position;

        print('_getCurrentLocation ${_position.latitude} ${_position.longitude}');
      });
      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _position.latitude, _position.longitude);

      Placemark place = p[0];

      setState(() {
        _address = place;
        print('_getAddressFromLatLng ${place.subThoroughfare}, ${place.thoroughfare}, ${place.name}, ${place.subAdministrativeArea}, ${place.administrativeArea}, ${place.subLocality}, ${place.locality}');
        // _address = "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }
}
