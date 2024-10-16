import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../generated/l10n.dart';
import '../utils/helpers.dart';
import '../rests/order_rest.dart';
import '../entities/apartment.dart';
import '../entities/order.dart';
import '../entities/user.dart';
import '../menu.dart';

class Orders extends StatelessWidget {
  User user;
  CustomMenuStatefulWidget parent;
  Apartment apartment;

  Orders(this.parent) ;

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  User user;
  CustomMenuStatefulWidget parent;
  Apartment apartment;
  CustomStatefulWidget(this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> {
  User user;
  Apartment apartment;
  Order order;
  CustomMenuStatefulWidget parent;
  List<Order> _orders = [];
  int _page = 1;
  bool _loading = false;
  bool _next = false;
  String _limit = '10';
  ScrollController controller;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
    user = this.parent.user;

    _page = 1;
    _parseOrder(this.parent.apartment, this.parent.searchQuery.text);
    this.parent.searchQuery.addListener((){
      _page = 1;
      _parseOrder(this.parent.apartment, this.parent.searchQuery.text);
    });
    controller = new ScrollController()..addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Expanded(child: _ordersWidget(context)),
          _loading ? LinearProgressIndicator() : Container(),
        ],
      ),
    );
  }

  Widget _getListItemTile(BuildContext context, int index) {
    if (_orders.length <= 0 || index >= _orders.length) return null;
    Order order = _orders[index];
    return GestureDetector(
      onTap: (){
        this.parent.order = order;
        this.parent.onMenuClicked('order_detail');
      },
      onLongPress: () {
      },
      child: Padding(
        padding: EdgeInsets.all(2),
        child: Column(
          children: <Widget>[
            Card(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: Text(order.order_no != null ? S.of(context).orderLetterNo+': ${order.order_no}' : (order.booking_no != null ? S.of(context).temporaryOrderLetterNo+': ${order.booking_no}' : ''))),
                        ActionChip(
                          backgroundColor: ['process','waiting','booked','approved'].contains(order.status) ? Colors.lightBlueAccent :
                            (['sold','cancel','sp1','sp2','sp3'].contains(order.status) ? Colors.redAccent :
                            ((['paid'].contains(order.status) ? Colors.green :
                            Colors.black38))),
                          label: Text(order.status),
                          onPressed: () {},
                        )
                      ],
                    ),
                    Text(order.name, textAlign: TextAlign.start),
                    Text('(${S.of(context).apartment}: ${order.apartment?.name} ${S.of(context).tower}: ${(order.apartment_unit !=null && order.apartment_unit.apartment_tower != null) ? order.apartment_unit.apartment_tower.name : '-'} ${S.of(context).floor}: ${order.apartment_unit !=null && order.apartment_unit.apartment_floor !=null ? order.apartment_unit.apartment_floor.name : '-'} ${S.of(context).no}:${order.apartment_unit?.unit_number})', textAlign: TextAlign.start),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.order_date),
                        Text(Helpers.currency(order.final_price)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // ListTile(
            //   title: Text(order.name, style: TextStyle(fontSize: 18)),
            //   subtitle: Text(order.address ?? (order.handphone ?? (order.email ?? '')), style: TextStyle(fontSize: 16)),
            // ),
            // Widget to display the list of project
          ],
        ),
      ),
        
      
    );
  }

  Widget _ordersWidget(BuildContext ctx) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      controller: controller,
      itemCount: _orders != null ? _orders.length : 0,
      itemBuilder: _getListItemTile,
    );
  }

  _parseOrder(Apartment apartment, String search){
    setState(() {
      _loading = true;
    });
    Map<String, String> query = new Map<String, String>();
    if (apartment != null) query.putIfAbsent('apartment_id', () => apartment.id.toString());
    query.putIfAbsent("marketing_id", () => user.id.toString());
    query.putIfAbsent("limit", () => _limit);
    query.putIfAbsent("page", () => _page.toString());
//        map.put("not_null[0]", "booking_no");
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
    if (search != null) query.putIfAbsent("search", () => search);

    OrderRest().getOrders(query).then((value) {
      if (mounted){
        setState(() {
          if (_page == 1) {
            _orders = value;
          } else {
            _orders.addAll(value);
          }
          _page++;
          if (value != null && value.length > 0){
            _next = true;
          } else {
            _next = false;
          }
          _loading = false;
        });
      }
    });
  }

  _scrollListener() {
    if (controller.position.extentAfter == 0) {
      setState(() {
        _parseOrder(this.parent.apartment, this.parent.searchQuery.text);
      });
    }
  }

}