import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    int oldSelection = oldValue.selection.baseOffset;
    int newSelection = newValue.selection.baseOffset;
    int newLength = newValue.text.length;

    if(newValue.selection.baseOffset == 0){
      return newValue;
    }

    double value = double.parse(newValue.text.replaceAll('.', ''));

    final formatter = NumberFormat.currency(locale: "id_ID", decimalDigits: 0, symbol: '');
    // final formatter = NumberFormat('#,###', 'id_ID');

    String newText = formatter.format(value);

    int additionalSelection = (newText.length - newLength).abs();

    if (newText.length > 1){
      return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newSelection + additionalSelection),
      );
    }

    return newValue.copyWith(
      text: newText,
      selection: new TextSelection.collapsed(offset: 1),
    );
  }
}
