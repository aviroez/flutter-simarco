import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../generated/l10n.dart';
import '../utils/currency_input_formatter.dart';
import '../utils/helpers.dart';
import '../rests/apartment_unit_rest.dart';
import '../rests/order_rest.dart';
import '../entities/apartment.dart';
import '../entities/apartment_tower.dart';
import '../entities/apartment_unit.dart';
import '../entities/order.dart';
import '../entities/user.dart';
import '../menu.dart';

class PaymentSchemas extends StatelessWidget {
  final User user;
  CustomMenuStatefulWidget parent;
  final Apartment apartment;

  PaymentSchemas(this.user, this.apartment, this.parent);

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
  CustomMenuStatefulWidget parent;
  var dropdownValue = 'Cash';
  final _formKey = GlobalKey<FormState>();
  double transactionPrice = 0;
  double bookingFee = 0;
  double dpPercent = 0;
  double dpValue = 0;
  double installmentValue = 0;
  double cashValue = 0;
  bool loading = false;
  List<DropdownMenuItem<String>> _dropdownPaymentType = [];

  _PaymentSchemaStatefulWidget(this.user, this.apartment, this.parent);

  TextEditingController textDpPercent = TextEditingController();
  TextEditingController textDpNumber = TextEditingController();
  TextEditingController textInstallmentNumber = TextEditingController();
  TextEditingController textCashNumber = TextEditingController();
  TextEditingController textTransactionPrice = TextEditingController();
  TextEditingController textBookingFee = TextEditingController();

  @override
  void initState() {
    super.initState();

    apartment_unit = this.parent.apartment_unit;

    textDpPercent.addListener(valueListener);
    textDpNumber.addListener(valueListener);
    textInstallmentNumber.addListener(valueListener);
    textCashNumber.addListener(valueListener);
    textTransactionPrice.addListener(valueListener);
    textBookingFee.addListener(valueListener);

    if (apartment_unit != null && apartment_unit.total_price != null) textTransactionPrice.text = Helpers.currency(apartment_unit.total_price);

    if (this.parent.order != null){
      setState(() {
        order = this.parent.order;
        if (order.apartment_unit != null) apartment_unit = order.apartment_unit;

        if (order.dp_percent != null) textDpPercent.text = Helpers.currency(order.dp_percent);
        if (order.dp_installment != null) textDpNumber.text = Helpers.toStr(order.dp_installment);
        if (order.installment_number != null) textInstallmentNumber.text = Helpers.toStr(order.installment_number);
        if (order.cash_number != null) textCashNumber.text = Helpers.toStr(order.cash_number);
        if (order.total_price != null) textTransactionPrice.text = Helpers.currency(order.total_price);
        textBookingFee.text = Helpers.currency(order.booking_fee);

        if (order.installment_number != null && order.installment_number > 0){
          dropdownValue = 'Installment';
        } else if (order.cash_number != null && order.cash_number > 0){
          dropdownValue = 'Cash';
        } else if (order.dp_percent != null && order.dp_percent > 0){
          dropdownValue = 'Kpa';
        }
      });
    }

    if (apartment_unit != null){
      // apartment_unit = this.parent.apartment_unit;
      Map<String, String> map = new Map();
      map.putIfAbsent("with[0]", () => "apartment");
      map.putIfAbsent("with[1]", () => "apartment_tower.apartment");
      map.putIfAbsent("with[2]", () => "apartment_type");
      map.putIfAbsent("with[3]", () => "apartment_view");
      map.putIfAbsent("with[4]", () => "apartment_floor");
      map.putIfAbsent("with[5]", () => "customer");

      ApartmentUnitRest().show(apartment_unit.id, map).then((value) {
        setState(() {
          if (value != null){
            this.parent.apartment_unit = value;
            apartment_unit = value;
          }
        });
      });
    }

    _dropdownPaymentType = [];
    for (String s in ['Cash', 'Installment', 'KPA']) {
      _dropdownPaymentType.add(
        DropdownMenuItem(
          child: Text(s),
          value: s,
        ),
      );
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
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.all(4),
                  child: Column(
                    children: [
                      ListTile(
                        // leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text('${S.of(context).apartment}: ${apartment_unit != null && apartment_unit.apartment != null ? (apartment_unit.apartment.name??apartment_unit.apartment.description) : (apartment!=null?(apartment.name??apartment.full_name):'')}'),
                        subtitle: Text(
                          '${S.of(context).tower}: ${apartment_unit != null && apartment_unit.apartment_tower != null ? (apartment_unit.apartment_tower.name??apartment_unit.apartment_tower.description) : ''}',
                          style: TextStyle(color: Colors.black.withOpacity(0.6)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                            child: Text('${S.of(context).floor}: ${apartment_unit != null && apartment_unit.apartment_floor != null ? (apartment_unit.apartment_floor.name??apartment_unit.apartment_floor.description) : '-'}'),
                          ),
                          Expanded(
                            child: Text('${S.of(context).no}: '+(apartment_unit != null ? apartment_unit.unit_number : '-')),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Text('${S.of(context).view}: ${apartment_unit != null && apartment_unit.apartment_view != null ? (apartment_unit.apartment_view.name??apartment_unit.apartment_view.description) : '-'}'),
                          ),
                          Expanded(
                            child: Text('${S.of(context).bedroom}: ${apartment_unit != null && apartment_unit.apartment_type != null ? (apartment_unit.apartment_type.bedroom_count??apartment_unit.apartment_type.name) : (apartment_unit.apartment_type_desc??'-')}'),
                          ),
                        ],
                      ),
                      (apartment_unit.total_price != null && apartment_unit.total_price > 0) ? Container(
                        alignment: Alignment.bottomRight,
                        child: Text((apartment_unit != null ? Helpers.currency(apartment_unit.total_price) : 'Rp 0'),
                            style: TextStyle(color: Colors.redAccent, fontSize: 16), textAlign: TextAlign.end
                        ),
                      ) : Container(),
                    ],
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Column(
                      children: [
                        ListTile(
                          // leading: Icon(Icons.arrow_drop_down_circle),
                          title: Text('${S.of(context).paymentSchema}:'),
                        ),
                        DropdownButtonFormField<String>(
                          items: _dropdownPaymentType,
                          value: dropdownValue,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: S.of(context).paymentType,
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String data) {
                            setState(() {
                              dropdownValue = data;
                            });
                          },
                          validator: (String data){
                            if (data == null) return S.of(context).paymentTypeIsRequired;
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Flexible(
                              flex: 5,
                              child: TextFormField(
                                controller: textDpPercent,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  CurrencyInputFormatter(),
                                ],
                                initialValue: null,
                                decoration: InputDecoration(
                                  labelText: S.of(context).dpPercentOrCurrency,
                                  border: OutlineInputBorder(),
                                  suffixText: S.of(context).percentOrCurrency,
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  double dp = Helpers.currencyRemove(textDpPercent.text);
                                  double bp = Helpers.currencyRemove(textBookingFee.text);
                                  double tp = Helpers.currencyRemove(textTransactionPrice.text);
                                  if (value.isNotEmpty && dp > (bp + tp)) return S.of(context).dpShouldNotBeMoreThanPrice;
                                  // if (value.isEmpty) return 'Dp Harus Diisi';
                                  return null;
                                },
                              ),
                            ),
                            Flexible(
                                flex: 2,
                                child: TextFormField(
                                  controller: textDpNumber,
                                  initialValue: null,
                                  decoration: InputDecoration(
                                    labelText: S.of(context).dpPaymentTimes,
                                    border: OutlineInputBorder(),
                                    suffixText: S.of(context).paymentTimes,
                                  ),
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value.isEmpty && textDpPercent.text.isNotEmpty) return S.of(context).dpPaymentTimesIsRequired;
                                    return null;
                                  },
                                )
                            ),
                          ],
                        ),
                        (dropdownValue=='Installment') ? SizedBox(height: 10) : Container(),
                        (dropdownValue=='Installment') ? TextFormField(
                          controller: textInstallmentNumber,
                          initialValue: null,
                          decoration: InputDecoration(
                            labelText: S.of(context).installmentNumber,
                            border: OutlineInputBorder(),
                            suffixText: S.of(context).paymentTimes,
                          ),
                          keyboardType: TextInputType.number,
                        ) : Container(),
                        (dropdownValue=='Cash') ? SizedBox(height: 10) : Container(),
                        (dropdownValue=='Cash') ? TextFormField(
                          controller: textCashNumber,
                          initialValue: null,
                          decoration: InputDecoration(
                            labelText: S.of(context).cashNumber,
                            border: OutlineInputBorder(),
                            suffixText: S.of(context).paymentTimes,
                          ),
                          keyboardType: TextInputType.number,
                        ) : Container(),
                      ],
                    )
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      ListTile(
                        // leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text('${S.of(context).priceDetail}:'),
                      ),
                      TextFormField(
                        controller: textTransactionPrice,
                        initialValue: null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: S.of(context).transactionPrice,
                          border: OutlineInputBorder(),
                          prefixText: S.of(context).currencyLocale,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).transactionPriceIsRequired;
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: textBookingFee,
                        initialValue: null,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          CurrencyInputFormatter(),
                        ],
                        decoration: InputDecoration(
                          labelText: S.of(context).bookingFee,
                          border: OutlineInputBorder(),
                          prefixText: S.of(context).currencyLocale,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value.isEmpty) return S.of(context).bookingFeeIsRequired;
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        // leading: Icon(Icons.arrow_drop_down_circle),
                        title: Text('${S.of(context).paymentSchemaDetail}:'),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          (bookingFee > 0) ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${S.of(context).bookingFee}:'),
                                Text(Helpers.currency(bookingFee)),
                              ],
                            ) : Container(),
                          (textDpPercent.text != null && textDpNumber.text != null && dpValue > 0) ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (dpPercent > 100) ? Text('${S.of(context).dp} (${textDpNumber.text}${S.of(context).paymentTimes}):') : Text('${S.of(context).dp} ${textDpPercent.text}% (${textDpNumber.text}${S.of(context).paymentTimes}):'),
                                Text(Helpers.currency(dpValue)),
                              ],
                            ) : Container(),
                          (textInstallmentNumber.text != null && dropdownValue == 'Installment' && installmentValue > 0) ?
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${S.of(context).installment} (${textInstallmentNumber.text}${S.of(context).paymentTimes}):'),
                                Text(Helpers.currency(installmentValue)),
                              ],
                            ) : Container(),
                          (textCashNumber.text != null && dropdownValue == 'Cash' && cashValue > 0) ?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${S.of(context).cash} (${textCashNumber.text}${S.of(context).paymentTimes}):'),
                              Text(Helpers.currency(cashValue)),
                            ],
                          ) : Container(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          this.parent.onMenuClicked('apartment_unit');
                        },
                        child: Text(S.of(context).back),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (apartment_unit != null && !loading){
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              this.parent.apartment_unit = apartment_unit;
                              this.parent.onMenuClicked('payment_schema');
                              double totalPrice = double.parse(textTransactionPrice?.text.replaceAll('.', ''));
                              double bookingFee = double.parse(textBookingFee?.text.replaceAll('.', ''));
                              double tax = _getVatAmountFromGross(totalPrice, 0.1);
                              double price = totalPrice - tax;
                              DateTime now = DateTime.now();
                              DateFormat formatter = DateFormat('yyyy-MM-dd');

                              Map<String, String> map = Map();
                              if (order != null && order.id > 0) map.putIfAbsent("id", () => order.id.toString());
                              map.putIfAbsent("apartment_id", () => apartment_unit.apartment_id.toString());
                              map.putIfAbsent("apartment_unit_id", () => apartment_unit.id.toString());
                              map.putIfAbsent("tax", () => tax.toString());
                              map.putIfAbsent("price", () => price.toString());
                              map.putIfAbsent("booking_fee", () => bookingFee.toString());
//                double discount = basePrice - offeredPrice;
//                if (discount > 1){
//                    map.put("discount", String.valueOf(discount));
//                }
//                int totalPrice = (int) (price+tax);
                              map.putIfAbsent("total_price", () => totalPrice.toString());
//                map.put("final_price", String.valueOf((int) (totalPrice-discount)));
                              map.putIfAbsent("final_price", () => totalPrice.toString());

                              map.putIfAbsent("order_date", () => formatter.format(now));
                              // if (paymentSchema != null) map.putIfAbsent("payment_schema_id", () => paymentSchema.id.toString());
                              // if (paymentType != null) map.putIfAbsent("payment_type_id", () => paymentType.id.toString());
                              if (textDpPercent != null) map.putIfAbsent("dp_percent", () => Helpers.removeDecimalZeroFormat(Helpers.currencyRemove(textDpPercent.text)));
                              if (textDpNumber != null) map.putIfAbsent("dp_installment", () => textDpNumber.text);
                              if (textInstallmentNumber != null && dropdownValue=='Installment') map.putIfAbsent("installment_number", () => textInstallmentNumber.text);
                              if (textCashNumber != null && dropdownValue=='Cash') map.putIfAbsent("cash_number", () => textCashNumber.text);

                              if (user != null) map.putIfAbsent("marketing_id", () => user.id.toString());
                              OrderRest().order(map).then((value) {
                                setState(() {
                                  loading = false;
                                  this.parent.order = value;
                                  this.parent.onMenuClicked('customer_identity');
                                });
                              }).catchError((catchError){
                                setState(() {
                                  loading = false;
                                });

                                var snackBar = SnackBar(content: Text(S.of(context).dataInputInvalid));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              });
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

  _getVatAmountFromGross(double grossAmount, double taxRate){
    return grossAmount / (1.0 + (1.0 / taxRate));
  }

  int intOrStringValue(dynamic o) =>
      (o is String ? int.tryParse(o) : o) ?? 0;

  valueListener(){
    setState(() {
      transactionPrice = 0;
      bookingFee = 0;
      if (textTransactionPrice != null && textTransactionPrice.text != null) transactionPrice = Helpers.currencyRemove(textTransactionPrice.text);
      if (textBookingFee != null && textBookingFee.text != null) bookingFee = Helpers.currencyRemove(textBookingFee.text);
      dpValue = 0;
      installmentValue = 0;
      cashValue = 0;

      if (transactionPrice != null && transactionPrice > 0){
        if (textDpPercent != null && textDpPercent.text != null && textDpNumber != null && textDpNumber.text != null){
          dpPercent = Helpers.currencyRemove(textDpPercent.text);
          if (dpPercent > 100){
            dpValue = dpPercent;
          } else {
            dpValue = (transactionPrice - bookingFee) * (dpPercent / 100);
          }
        }
        if (textInstallmentNumber.text != null){
          installmentValue = transactionPrice - bookingFee - dpValue;
        }
        if (textCashNumber.text != null){
          cashValue = transactionPrice - bookingFee - dpValue;
        }
      }
    });
  }
}