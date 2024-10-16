import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import '../generated/l10n.dart';
import '../utils/helpers.dart';
import '../entities/customer_lead_join.dart';
import '../rests/event_rest.dart';
import '../entities/customer.dart';
import '../entities/customer_lead.dart';
import '../rests/customer_lead_rest.dart';
import '../rests/customer_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_unit.dart';
import '../entities/order.dart';
import '../entities/user.dart';
import '../menu.dart';

class EventAdds extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  EventAdds(this.parent);

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
  Apartment apartment;
  ApartmentTower apartment_tower;
  ApartmentUnit apartment_unit;
  Customer _customer;
  CustomerLead _customer_lead;
  CustomMenuStatefulWidget parent;
  var _gender = 'm';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  _PaymentSchemaStatefulWidget(this.parent);

  TextEditingController textEventName = TextEditingController();
  TextEditingController textStartDate = TextEditingController();
  TextEditingController textEndDate = TextEditingController();
  TextEditingController textEventAddress = TextEditingController();
  TextEditingController textEventDescription = TextEditingController();

  @override
  void initState() {
    super.initState();
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
              DropdownSearch<Apartment>(
                mode: Mode.MENU,
                autoFocusSearchBox: true,
                selectedItem: apartment,
                label: S.of(context).apartment,
                onFind: (String filter) async {
                  return this.parent.listApartment;
                },
                itemAsString: (Apartment u) {
                  return u.name;
                },
                onChanged: (Apartment data) {
                  setState(() {
                    apartment = data;
                  });
                },
                validator: (Apartment data) {
                  if (data == null) return S.of(context).apartmentIsRequired;
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textEventName,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).eventName,
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value.isEmpty) return S.of(context).eventNameIsRequired;
                  return null;
                },
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  _startDatePicker(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    onTap: () async {
                      _startDatePicker(context);
                    },
                    controller: textStartDate,
                    initialValue: null,
                    decoration: InputDecoration(
                        labelText: S.of(context).startDate,
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event)
                    ),
                    validator: (value) {
                      if (value.isEmpty && textEndDate.text.isEmpty) return S.of(context).startEndDateIsRequired;
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () async {
                  _endDatePicker(context);
                },
                child: AbsorbPointer(
                  child: TextFormField(
                    controller: textEndDate,
                    initialValue: null,
                    decoration: InputDecoration(
                        labelText: S.of(context).endDate,
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.event_available_outlined)
                    ),
                    validator: (value) {
                      if (value.isEmpty && textStartDate.text.isEmpty) return S.of(context).startEndDateIsRequired;
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textEventAddress,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).eventAddress,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: textEventDescription,
                initialValue: null,
                decoration: InputDecoration(
                  labelText: S.of(context).eventDescription,
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      this.parent.onMenuClicked('events');
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
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Customer>> _parseCustomer(search) async {
    Map<String, String> map = new Map();
    map.putIfAbsent("marketing_id", () => user.id.toString());
    if (search.length > 0) map.putIfAbsent("search", () => search);

    return await CustomerRest().getCustomers(map);
  }

  Future<List<CustomerLead>> _parseCustomerLead(search) async {
    Map<String, String> map = new Map();
    map.putIfAbsent("marketing_id", () => user.id.toString());
    if (search.length > 0) map.putIfAbsent("search", () => search);

    return await CustomerLeadRest().getCustomerLeads(map);
  }

  void _prosesAction() {
    if (_formKey.currentState.validate()) {
      Map<String, String> map = new Map();
      map.putIfAbsent("name", () => textEventName.text);
      map.putIfAbsent("address", () => textEventAddress.text);
      map.putIfAbsent("description", () => textEventDescription.text);
      map.putIfAbsent("gender", () => _gender);
      if (apartment != null && apartment.id > 0) map.putIfAbsent(
          "apartment_id", () => apartment.id.toString());
      if (textStartDate != null) map.putIfAbsent(
          "start_date", () => textStartDate.text);
      if (textEndDate != null) map.putIfAbsent(
          "end_date", () => textEndDate.text);
      // if (latitude != 0 && longitude != 0){
      //   map.putIfAbsent("latitude", () => (latitude));
      //   map.putIfAbsent("longitude", () => (longitude));
      // }

      EventRest().add(map).then((value) {
        if (value != null) {
          setState(() {
            this.parent.event = value;
          });

          this.parent.onMenuClicked('events');
        }
      });
    }
  }

  Future<Null> _startDatePicker(BuildContext context) async {
    int y = DateTime.now().year;
    int m = 1;
    int d = 1;
    if (textStartDate != null && textStartDate.text != null && textStartDate.text.length > 0){
      var currentDate = textStartDate.text.split('-');
      y = Helpers.toInt(currentDate[0]);
      m = Helpers.toInt(currentDate[1]);
      d = Helpers.toInt(currentDate[2]);
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(y, m, d),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100)
    );
    if (picked != null && picked != _startDate)
      setState(() {
        _startDate = picked;
        textStartDate.value = TextEditingValue(text: picked.toString().replaceAll(' 00:00:00.000', ''));
      });
  }

  Future<Null> _endDatePicker(BuildContext context) async {
    int y = DateTime.now().year;
    int m = 1;
    int d = 1;
    if (textEndDate != null && textEndDate.text != null && textEndDate.text.length > 0){
      var currentDate = textEndDate.text.split('-');
      y = Helpers.toInt(currentDate[0]);
      m = Helpers.toInt(currentDate[1]);
      d = Helpers.toInt(currentDate[2]);
    }
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(y, m, d),
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != _endDate)
      setState(() {
        _endDate = picked;
        textEndDate.value = TextEditingValue(text: picked.toString().replaceAll(' 00:00:00.000', ''));
      });
  }

  _parseValue(CustomerLeadJoin clj, Order order){
    setState(() {
      if (order != null){
        textEventName.text = order.name;
        textEventAddress.text = order.address;
        textEventDescription.text = order.address_correspondent;
      } else if (clj != null){
        if (clj.customer_lead != null){
          _customer_lead = clj.customer_lead;
          textEventName.text = _customer_lead.name;
          textEventAddress.text = _customer_lead.address;
          textEventDescription.text = _customer_lead.address_correspondent;
        } else if (clj.customer != null){
          _customer = clj.customer;
          textEventName.text = _customer.name;
          textEventAddress.text = _customer.address;
          textEventDescription.text = _customer.address_correspondent;
        }
      }
    });
  }
}
