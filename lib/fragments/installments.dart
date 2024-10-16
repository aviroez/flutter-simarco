import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:jiffy/jiffy.dart';
import 'package:simarco/generated/l10n.dart';
import '../entities/order.dart';
import '../rests/order_rest.dart';
import '../utils/helpers.dart';
import '../menu.dart';

class Installments extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Installments(this.parent) ;

  @override
  Widget build(BuildContext context) {
    return CustomStatefulWidget(this.parent);
  }
}
class CustomStatefulWidget extends StatefulWidget {
  CustomMenuStatefulWidget parent;
  CustomStatefulWidget(this.parent);

  @override
  _CustomStatefulWidget createState() => _CustomStatefulWidget(this.parent);
}

class _CustomStatefulWidget extends State<CustomStatefulWidget> {
  Order order;
  CustomMenuStatefulWidget parent;
  List<DataRow> _listDataRow = [];
  Map<String, String> map = new Map();
  bool loading = false;

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
    order = this.parent.order;
    if (order != null){
      setState(() {
        int number = 0;
        double finalPrice = order.final_price;
        double calculationPrice = 0;
        if (order.booking_fee != null && order.booking_fee > 0) {
          var threeDaysFromNow = Jiffy()
            ..add(duration: Duration(days: 3));

          map.putIfAbsent("description[$number]", () => "Booking Fee 1");
          map.putIfAbsent(
              "installment_price[$number]", () => Helpers.removeLastCommaZero(order.booking_fee));
          map.putIfAbsent(
              "due_date[$number]", () => threeDaysFromNow.format('yyyy-MM-dd'));
          map.putIfAbsent("type[$number]", () => "booking_fee");

          _listDataRow.add(
              DataRow(
                cells: <DataCell>[
                  DataCell(Text((++number).toString())),
                  DataCell(Text('Booking Fee 1')),
                  DataCell(_currencyRight(order.booking_fee)),
                  DataCell(Text(threeDaysFromNow.format('dd/MM/yyyy'))),
                ],
              )
          );

          calculationPrice += order.booking_fee;
        }

        var today = Jiffy();
        if (order.dp_percent != null && order.dp_percent > 0 &&
            order.dp_installment != null && order.dp_installment > 0) {
          double value = ((finalPrice - calculationPrice) *
              (order.dp_percent / 100) / order.dp_installment).floorToDouble();
          if (order.dp_percent > 100){
            value = (order.dp_percent / order.dp_installment).floorToDouble();
          }
          for (int i = 0; i < order.dp_installment; i++) {
            today.add(months: 1);
            map.putIfAbsent("description[$number]", () => "Down Payment " +
                (i + 1).toString());
            map.putIfAbsent(
                "installment_price[$number]", () => Helpers.removeLastCommaZero(value));
            map.putIfAbsent(
                "due_date[$number]", () => today.format('yyyy-MM-dd'));
            map.putIfAbsent("type[$number]", () => "dp");

            calculationPrice += value;

            _listDataRow.add(
                DataRow(
                  cells: <DataCell>[
                    DataCell(Text((++number).toString())),
                    DataCell(Text('Down Payment ${i+1}')),
                    DataCell(_currencyRight(value)),
                    DataCell(Text(today.format('dd/MM/yyyy'))),
                  ],
                )
            );
          }
        }

        if (order.installment_number != null && order.installment_number > 0) {
          double firstValue = 0;
          double value = ((finalPrice - calculationPrice) /
              order.installment_number).floorToDouble();
          if (value > 0){
            if (order.installment_number > 1) {
              firstValue = (finalPrice - calculationPrice) -
                  (value * (order.installment_number - 1));
            }

            for (int i = 0; i < order.installment_number; i++) {
              today.add(months: 1);

              var currentValue = value;
              if (i == 0 && firstValue > value) {
                currentValue = firstValue;
              }
              calculationPrice += currentValue;

              map.putIfAbsent("description[$number]", () => "Installment " +
                  (i + 1).toString());
              map.putIfAbsent(
                  "installment_price[$number]", () => Helpers.removeLastCommaZero(currentValue));
              map.putIfAbsent(
                  "due_date[$number]", () => today.format('yyyy-MM-dd'));
              map.putIfAbsent("type[$number]", () => "installment");

              _listDataRow.add(
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text((++number).toString())),
                      DataCell(Text('Installment '+(i+1).toString())),
                      DataCell(_currencyRight(currentValue)),
                      DataCell(Text(today.format('dd/MM/yyyy'))),
                    ],
                  )
              );
            }
          }
        }

        if (order.cash_number != null && order.cash_number > 0) {
          double firstValue = 0;
          double value = ((finalPrice - calculationPrice) /
              order.cash_number).floorToDouble();
          if (value > 0){
            if (order.cash_number > 1) {
              firstValue = (finalPrice - calculationPrice) -
                  (value * (order.cash_number - 1));
            }

            for (int i = 0; i < order.cash_number; i++) {
              today.add(months: 1);

              var currentValue = value;
              if (i == 0 && firstValue != value) {
                currentValue = firstValue;
              }
              calculationPrice += currentValue;

              map.putIfAbsent("description[$number]", () => "Installment " +
                  (i + 1).toString());
              map.putIfAbsent(
                  "installment_price[$number]", () => Helpers.removeLastCommaZero(currentValue));
              map.putIfAbsent(
                  "due_date[$number]", () => today.format('yyyy-MM-dd'));
              map.putIfAbsent("type[$number]", () => "tunai");

              _listDataRow.add(
                  DataRow(
                    cells: <DataCell>[
                      DataCell(Text((++number).toString())),
                      DataCell(Text('Cash '+(i+1).toString())),
                      DataCell(_currencyRight(currentValue)),
                      DataCell(Text(today.format('dd/MM/yyyy'))),
                    ],
                  )
              );
            }
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
      padding: EdgeInsets.all(2.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              child: Column(
                children: [
                  Text(order.order_no != null ? S.of(context).orderLetter : S.of(context).temporaryOrderLetter),
                  (order.order_no != null || order.booking_no != null) ? Text(order.order_no != null ? S.of(context).orderLetterNo + ': ${order.order_no}' : S.of(context).temporaryOrderLetterNo + ': ${order.booking_no}') : Container(),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).signedBelow+':'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).fullNameLabel),
                      Text(order.name ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).idLabel),
                      Text(order.nik ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).addressLabel),
                      Text(order.address ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).addressCorrespondentLabel),
                      Text(order.address_correspondent ?? ''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).phoneNumberOrLineOrEmailLabel),
                      Text(order.phone_number ?? '' + ' ' +order.email),
                    ],
                  ),
                  Text(S.of(context).laterCalledOrder),
                ],
              ),
            ),
            Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(S.of(context).statingThat+':'),
                  Column(
                    children: [
                      Text(S.of(context).hasBeenOrdering),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).apartmentLabel),
                      Text(''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).towerLabel),
                      Text(''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).floorLabel),
                      Text(''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).unitNumberLabel),
                      Text(''),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).priceLabel),
                      Text(Helpers.currency(order.price)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).tax10Label),
                      Text(Helpers.currency(order.tax)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).discountLabel),
                      Text(Helpers.currency(order.discount)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).priceAfterDiscountLabel),
                      Text(Helpers.currency(order.total_price)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).bookingFeeLabel),
                      Text(Helpers.currency(order.booking_fee)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).finalPriceLabel),
                      Text(Helpers.currency(order.final_price)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(S.of(context).inNumberlabel),
                      Text(Helpers.penyebut(order.final_price) + ' ' + S.of(context).currencyFullLocale),
                    ],
                  ),
                ],
              ),
            ),
            Card(
              child: Column(
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        this.parent.onMenuClicked('scan_document');
                      },
                      child: Text(S.of(context).back),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (order != null && !loading){
                          setState(() {
                            loading = true;
                          });
                          OrderRest().installments(order.id, map).then((value){
                            setState(() {
                              loading = false;
                            });
                            this.parent.order = value;
                            this.parent.onMenuClicked('tos');
                          }).catchError((catchError){
                            setState(() {
                              loading = false;
                            });

                            var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          });
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
    );
  }

  _currencyRight(price){
    return Container(child: Text(Helpers.currency(price), textAlign: TextAlign.end), alignment: Alignment.centerRight);
  }
}