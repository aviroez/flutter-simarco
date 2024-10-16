import 'package:flutter/material.dart';
import 'package:simarco/generated/l10n.dart';
import '../entities/order_installment.dart';
import '../utils/helpers.dart';
import '../rests/order_rest.dart';
import '../entities/apartment.dart';
import '../entities/order.dart';
import '../entities/user.dart';
import '../menu.dart';

class OrderDetails extends StatelessWidget {
  User user;
  CustomMenuStatefulWidget parent;
  Apartment apartment;

  OrderDetails(this.parent) ;

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
  List<DataRow> _listDataRow = [];

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
    user = this.parent.user;
    order = this.parent.order;
    if (order != null){
      _parseOrder(order);
      if (order.order_installments != null){
        int number = 0;
        _listDataRow = [];
        for(OrderInstallment oi in order.order_installments){
          setState(() {
            _listDataRow.add(
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text((++number).toString())),
                    DataCell(Text(oi.description)),
                    DataCell(Container(child: Text(Helpers.currency(oi.price), textAlign: TextAlign.end), alignment: Alignment.centerRight)),
                    DataCell(Container(child: Text(Helpers.reformatDate(oi.due_date), textAlign: TextAlign.end), alignment: Alignment.centerRight)),
                  ],
                )
            );
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Column(
                children: [
                  Text(order.order_no != null ? S.of(context).orderLetter : S.of(context).temporaryOrderLetter),
                  Text(order.order_no != null ? S.of(context).orderLetterNo + ': ${order.order_no}' : S.of(context).temporaryOrderLetterNo + ': ${order.booking_no}'),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).fullNameLabel)),
                      Text(order.name ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).idLabel)),
                      Text(order.nik ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).addressLabel)),
                      Text(order.address ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).addressCorrespondentLabel)),
                      Text(order.address_correspondent ?? ''),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).phoneNumberOrLineOrEmailLabel)),
                      Text(order.phone_number ?? '' + ' ' + (order.email ?? '-')),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).apartmentLabel)),
                      Text(order.apartment!=null ? order.apartment.name : '-'),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).towerLabel)),
                      Text(order.apartment_unit != null && order.apartment_unit.apartment_tower != null ? order.apartment_unit.apartment_tower.name : '-'),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).floorLabel)),
                      Text(order.apartment_unit != null && order.apartment_unit.apartment_floor != null ? order.apartment_unit.apartment_floor.name : '-'),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).unitNumberLabel)),
                      Text(order.apartment_unit != null ? order.apartment_unit.unit_number : '-'),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).priceLabel)),
                      Text(Helpers.currency(order.price)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).tax10Label)),
                      Text(Helpers.currency(order.tax)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).discountLabel)),
                      Text(Helpers.currency(order.discount)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).priceAfterDiscountLabel)),
                      Text(Helpers.currency(order.total_price)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).bookingFeeLabel)),
                      Text(Helpers.currency(order.booking_fee)),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: Text(S.of(context).finalPriceLabel)),
                      Text(Helpers.currency(order.final_price)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).inNumberlabel),
                      Text(Helpers.penyebut(order.final_price) + ' '+S.of(context).currencyFullLocale),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).paymentMethodLabel),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(S.of(context).no),
                        ),
                        DataColumn(
                          label: Text(S.of(context).description),
                        ),
                        DataColumn(
                          label: Text(S.of(context).price),
                        ),
                        DataColumn(
                          label: Text(S.of(context).dueDate),
                        ),
                      ],
                      rows: _listDataRow,
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton(
                onPressed: (){
                  setState(() {
                    this.parent.order = null;
                  });
                  this.parent.onMenuClicked('order');
                },
                child: Text(S.of(context).back)
            ),
          ],
        ),
      ),
    );
  }

  _parseOrder(Order order){
    Map<String, String> query = new Map<String, String>();
    if (apartment != null) query.putIfAbsent('apartment_id', () => apartment.id.toString());
    // query.putIfAbsent("marketing_id", () => user.id.toString());
    // query.putIfAbsent("limit", () => '10');
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
    // if (search != null) query.putIfAbsent("search", () => search);

    OrderRest().show(order.id, query).then((value) {
      if (mounted){
        setState(() {
          order = value;
        });
      }
    });
  }

}