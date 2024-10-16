import 'package:flutter/material.dart';
import '../entities/customer_lead.dart';
import '../rests/customer_lead_rest.dart';
import '../rests/customer_rest.dart';
import '../entities/apartment.dart';
import '../entities/customer.dart';
import '../entities/user.dart';
import '../menu.dart';

class Customers extends StatelessWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;

  Customers(this.user, this.apartment, this.parent) ;

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.user, this.apartment, this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;
  CustomStatefulWidget(this.user, this.apartment, this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.user, this.apartment, this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> {
  final User user;
  Apartment apartment;
  Customer customer;
  CustomMenuStatefulWidget parent;
  int pageCustomer = 1;
  int pageCustomerLead = 1;
  List<Customer> _customers = [];
  List<CustomerLead> _customer_leads = [];
  String _search = '';
  String _limit = '10';
  bool _loading_customer = false;
  bool _loading_customer_lead = false;
  bool _nextCustomer = true;
  bool _nextCustomerLead = true;
  ScrollController customerController;
  ScrollController customerLeadController;

  _CustomStatefulWidget(this.user, this.apartment, this.parent);

  @override
  void initState() {
    super.initState();

    _loadList();
    this.parent.searchQuery.addListener((){
      _loadList();
    });

    customerController = new ScrollController()..addListener(_scrollCustomerListener);
    customerLeadController = new ScrollController()..addListener(_scrollCustomerLeadListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(child: this.parent.selectedCustomerIndex == 1 ? _customerLeadsWidget(context) : _customersWidget(context)),
          _loading_customer || _loading_customer_lead ? LinearProgressIndicator() : Container(),
        ],
      ),
    );
  }

  Widget _getCustomerItemTile(BuildContext context, int index) {
    if (_customers.length <= 0 || index >= _customers.length) return null;
    Customer customer = _customers[index];
    return GestureDetector(
      onTap: (){
        this.parent.customer = customer;
        this.parent.onMenuClicked('customer_detail');
      },
      onPanEnd: (DragEndDetails details){
        print('onPanEnd customer ${details.primaryVelocity}');
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(customer.name, style: TextStyle(fontSize: 18)),
            subtitle: Text(customer.email ?? (customer.handphone ?? ''), style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _getCustomerLeadItemTile(BuildContext context, int index) {
    if (_customer_leads.length <= 0 || index >= _customer_leads.length) return null;
    CustomerLead customerLead = _customer_leads[index];
    return GestureDetector(
      onTap: (){
        this.parent.customer_lead = customerLead;
        this.parent.onMenuClicked('customer_detail');
      },
      onLongPress: () {
      },
      // onVerticalDragEnd: (DragEndDetails details) {
      //   print('onVerticalDragEnd customerlead ${details.primaryVelocity}');
      //   if (_nextCustomerLead) _parseCustomerLead(pageCustomerLead, this.parent.searchQuery.text);
      // },
      onPanEnd: (DragEndDetails details){
        print('onPanEnd customerlead ${details.primaryVelocity}');
      },
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(customerLead.name ?? '', style: TextStyle(fontSize: 18)),
            subtitle: Text(customerLead.email ?? (customerLead.handphone ?? ''), style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _customersWidget(BuildContext ctx) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: customerController,
      // physics: ScrollPhysics(),
      itemCount: _customers != null ? _customers.length : 0,
      itemBuilder: _getCustomerItemTile,
    );
  }

  Widget _customerLeadsWidget(BuildContext ctx) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: customerLeadController,
      itemCount: _customer_leads != null ? _customer_leads.length : 0,
      itemBuilder: _getCustomerLeadItemTile,
    );
  }

  _parseCustomer(search){
    if (_nextCustomer && !_loading_customer){
      setState(() {
        _loading_customer = true;
      });
      Map<String, String> query = new Map<String, String>();
      query.putIfAbsent('marketing_id', () => user.id.toString());
      query.putIfAbsent('page', () => pageCustomer.toString());
      query.putIfAbsent('limit', () => _limit);
      if (search != null && search.length > 0) query.putIfAbsent('search', () => search);
      CustomerRest().getCustomers(query).then((value) {
        setState(() {
          _loading_customer = false;
        });
        if (value != null){
          setState(() {
            if (pageCustomer == 1) {
              _customers = value;
            } else {
              _customers.addAll(value);
            }
          });
          pageCustomer++;
          if (value != null && value.length > 0){
            _nextCustomer = true;
          } else {
            _nextCustomer = false;
          }
        } else {
          _nextCustomer = false;
        }
      }).catchError((onError){
        _nextCustomer = false;
        setState(() {
          _loading_customer = false;
        });
      });
    }
  }

  _parseCustomerLead( search){
    if (_nextCustomerLead && !_loading_customer_lead){
      setState(() {
        _loading_customer_lead = true;
      });
      Map<String, String> query = new Map<String, String>();
      query.putIfAbsent('marketing_id', () => user.id.toString());
      query.putIfAbsent('page', () => pageCustomerLead.toString());
      query.putIfAbsent('limit', () => _limit);
      if (search != null && search.length > 0) query.putIfAbsent('search', () => search);
      CustomerLeadRest().getCustomerLeads(query).then((value) {
        setState(() {
          _loading_customer_lead = false;
        });
        if (value != null){
          setState(() {
            if (pageCustomerLead == 1) {
              _customer_leads = value;
            } else {
              _customer_leads.addAll(value);
            }
          });
          pageCustomerLead++;
          if (value != null && value.length > 0){
            _nextCustomerLead = true;
          } else {
            _nextCustomerLead = false;
          }
        } else {
          _nextCustomerLead = false;
        }
      }).catchError((onError){
        _nextCustomerLead = false;
        setState(() {
          _loading_customer_lead = false;
        });
      });
    }
  }

  _loadList(){
    _nextCustomer = true;
    _nextCustomerLead = true;
    pageCustomer = 1;
    pageCustomerLead = 1;
    _parseCustomer(this.parent.searchQuery.text);
    _parseCustomerLead(this.parent.searchQuery.text);
  }

  _scrollCustomerListener() {
    if (customerController.position.extentAfter == 0) {
      setState(() {
        _parseCustomer(this.parent.searchQuery.text);
      });
    }
  }

  _scrollCustomerLeadListener() {
    if (customerLeadController.position.extentAfter == 0) {
      setState(() {
        _parseCustomerLead(this.parent.searchQuery.text);
      });
    }
  }

}