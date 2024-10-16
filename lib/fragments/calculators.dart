import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/currency_input_formatter.dart';
import '../utils/helpers.dart';
import '../entities/event.dart';
import '../entities/apartment.dart';
import '../entities/user.dart';
import '../menu.dart';

class Calculators extends StatelessWidget {
  CustomMenuStatefulWidget parent;

  Calculators(this.parent) ;

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
  User user;
  Apartment apartment;
  Event event;
  CustomMenuStatefulWidget parent;
  double _loanTerm;
  double _result;
  bool _card_result = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController textNominal = TextEditingController();
  TextEditingController textTerm = TextEditingController();
  TextEditingController textPercent = TextEditingController();

  _CustomStatefulWidget(this.parent);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(1),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textNominal,
                      initialValue: null,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CurrencyInputFormatter(),
                      ],
                      decoration: InputDecoration(
                        labelText: 'Nominal',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return 'Nominal Harus Diisi';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textTerm,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: 'Tenor (Tahun)',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return 'Tenor Harus Diisi';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: textPercent,
                      initialValue: null,
                      decoration: InputDecoration(
                        labelText: 'Bunga %',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.isEmpty) return 'Bunga Harus Diisi';
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        _calculate();
                      },
                      child: Text('Hitung'),
                    ),
                  ],
                ),
              ),
            ),
            _card_result ? Card(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _loanTerm != null ? Text('Jumlah Cicilan: ${Helpers.toInt(_loanTerm*12)} x') : Container(),
                    _result != null ? Text('Cicilan per bulan: Rp ${Helpers.currency(_result)}') : Container(),
                  ],
                ),
              ),
            ) : Container(),
          ],
        ),
      ),
    );
  }

  _calculate(){
    if (_formKey.currentState.validate()){
      double interest = Helpers.toDouble(textPercent.text)/100;
      double top = interest/12;
      setState(() {
        _card_result = true;
        _loanTerm = Helpers.toDouble(textTerm.text);
        double bottom = 1 - pow(1+(interest/12), - _loanTerm*12);

        _result = Helpers.toDouble(textNominal.text.replaceAll('.', '')) * (top / bottom);
        print('calculate ${_loanTerm} ${_result}');
      });
    } else {
      setState(() {
        _card_result = false;
      });
    }
  }

}